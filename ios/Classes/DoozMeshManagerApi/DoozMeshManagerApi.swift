//
//  DoozMeshManagerApi.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 29/05/2020.
//

import Foundation
import nRFMeshProvision

class DoozMeshManagerApi: NSObject{
    
    //MARK: Public properties
    var meshNetworkManager: MeshNetworkManager
    var delegate: DoozMeshManagerApiDelegate?
    var eventSink: FlutterEventSink?
    var mtuSize: Int = -1
    
    //MARK: Private properties
    private var doozMeshNetwork: DoozMeshNetwork?
    
    private let messenger: FlutterBinaryMessenger
    private var doozStorage: LocalStorage
    
    private var doozProvisioningManager: DoozProvisioningManager
    private var doozTransmitter: DoozTransmitter
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        self.doozTransmitter = DoozTransmitter()
        self.doozStorage = LocalStorage(fileName: DoozStorage.fileName)
        
        self.meshNetworkManager = MeshNetworkManager(using: doozStorage)
        self.meshNetworkManager.acknowledgmentTimerInterval = 0.150
        self.meshNetworkManager.transmissionTimerInteral = 0.600
        self.meshNetworkManager.incompleteMessageTimeout = 10.0
        self.meshNetworkManager.retransmissionLimit = 2
        self.meshNetworkManager.acknowledgmentMessageInterval = 4.2
        self.meshNetworkManager.acknowledgmentMessageTimeout = 40.0
        self.meshNetworkManager.transmitter = doozTransmitter
        
        self.doozProvisioningManager = DoozProvisioningManager(meshNetworkManager: meshNetworkManager, messenger: messenger)
        
        super.init()
        
        meshNetworkManager.logger = self
        meshNetworkManager.delegate = self
        doozTransmitter.doozDelegate = self
        doozProvisioningManager.delegate = self
        
        self.delegate = self
        
        _initChannels(messenger: messenger)
    }
    
}


private extension DoozMeshManagerApi {
    
    func _initChannels(messenger: FlutterBinaryMessenger){
        
        FlutterEventChannel(
            name: FlutterChannels.MeshManagerApi.getEventChannelName(),
            binaryMessenger: messenger
        )
        .setStreamHandler(self)
        
        FlutterMethodChannel(
            name: FlutterChannels.MeshManagerApi.getMethodChannelName(),
            binaryMessenger: messenger
        )
        .setMethodCallHandler({ (call, result) in
            self._handleMethodCall(call, result: result)
        })
        
    }
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        
        let _method = DoozMeshManagerApiChannel(call: call)
        
        switch _method {
        
        case .error(let error):
            switch error {
            case FlutterCallError.notImplemented:
                result(FlutterMethodNotImplemented)
            default:
                #warning("manage other errors")
                print("❌ Plugin method - \(call.method) - isn't implemented")
            }
        
        case .loadMeshNetwork:
            do {
                let error = AccessError.invalidElement
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: error.localizedDescription, details: nil))
//                let network = try _loadMeshNetwork()
//                delegate?.onNetworkLoaded(network)
//                result(nil)
            }catch {
                delegate?.onNetworkLoadFailed(error)
            }
            
            
        case .importMeshNetworkJson(let data):
            do{
                try _importMeshNetworkJson(data.json)
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
            
        case .deleteMeshNetworkFromDb(let data):
            
            do{
                try _deleteMeshNetworkFromDb(data.id)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
        case .exportMeshNetwork:
            if let json = _exportMeshNetwork(){
                result(json)
            }
            break
        case .identifyNode(var data):
            do{
                try doozProvisioningManager.identifyNode(data.uuid)
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
        case .provisioning:
            do{
                try doozProvisioningManager.provision()
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
        case .handleNotifications(let data):
            
            _didDeliverData(data: data.pdu.data)
            result(nil)
        
        case .setMtuSize(let data):
            
            delegate?.mtuSize = data.mtuSize
            result(nil)
            
        case .cleanProvisioningData:
            
            doozProvisioningManager.cleanProvisioningData()
            result(nil)
            
        case .sendConfigCompositionDataGet(let data):
            
            doozProvisioningManager.sendConfigCompositionDataGet(data.dest)
            result(nil)
            
        case .sendConfigAppKeyAdd(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys.first else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            doozProvisioningManager.sendConfigAppKeyAdd(dest: data.dest, appKey: appKey)
            result(nil)
            
        case .sendGenericLevelSet(let data):
            #warning("TODO : add transitionTime and delay")
            
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: T##String, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            let message = GenericLevelSet(level: data.level)
            do{
                
                _ = try meshNetworkManager.send(
                    message,
                    to: MeshAddress(Address(bitPattern: data.address)),
                    using: appKey
                )
                
                result(nil)
                
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                print(error)
            }
            
            
        case .sendGenericOnOffSet(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: T##String, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            
            let message = GenericOnOffSet(data.value)
            
            do{
                _ = try meshNetworkManager.send(
                    message,
                    to: MeshAddress(Address(bitPattern: data.address)),
                    using: appKey
                )
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                print(error)
            }
            
        case .sendConfigModelSubscriptionAdd(let data):
            #warning("❌ TO TEST")
            
            if
                let group = meshNetworkManager.meshNetwork?.group(withAddress: MeshAddress(Address(bitPattern: data.subscriptionAddress))),
                
                let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(bitPattern: data.address)),
                let element = node.element(withAddress: Address(bitPattern: data.elementAddress)),
                let model = element.model(withModelId: data.modelIdentifier){
                
                let message: ConfigMessage =
                    ConfigModelSubscriptionAdd(group: group, to: model) ??
                    ConfigModelSubscriptionVirtualAddressAdd(group: group, to: model)!
                
                do{
                    _ = try meshNetworkManager.send(message, to: model)
                    result(true)
                }catch{
                    #warning("TODO : manage errors")
                    //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                    print(error)
                    result(nil)
                }
            }
            
        case .sendConfigModelSubscriptionDelete(let data):
            #warning("❌ TO TEST")
            
            if
                let group = meshNetworkManager.meshNetwork?.group(withAddress: MeshAddress(Address(bitPattern: data.subscriptionAddress))),
                
                let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(bitPattern: data.address)),
                let element = node.element(withAddress: Address(bitPattern: data.elementAddress)),
                let model = element.model(withModelId: data.modelIdentifier){
                
                let message: ConfigMessage =
                    ConfigModelSubscriptionDelete(group: group, from: model) ??
                    ConfigModelSubscriptionVirtualAddressDelete(group: group, from: model)!
                
                do{
                    _ = try meshNetworkManager.send(message, to: model)
                    result(true)
                }catch{
                    #warning("TODO : manage errors")
                    //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                    print(error)
                    result(nil)
                }
            }
            
        case .sendConfigModelAppBind(let data):
            do{
                let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(bitPattern: data.nodeId))
                let element = node?.element(withAddress: Address(bitPattern: data.elementId))
                let model = element?.model(withModelId: data.modelId)
                let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.appKeyIndex)]
                
                if let _appKey = appKey, let _model = model{
                    
                    if let configModelAppBind = ConfigModelAppBind(applicationKey: _appKey, to: _model){
                        try _ =  meshNetworkManager.send(configModelAppBind, to: _model)
                        result(nil)
                    }
                }
                
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                print(error)
            }
            
        case .getSequenceNumberForAddress(let data):
            #warning("check if only one node ?")
            if
                let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(bitPattern: data.address)),
                _node.elementsCount > 0{
                
                let sequenceNumber = meshNetworkManager.getSequenceNumber(ofLocalElement: _node.elements[0])
                result(sequenceNumber)
                
            }else{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                result(nil)
            }
            
        }
        
    }
    
}


private extension DoozMeshManagerApi{
    
    func _loadMeshNetwork() throws -> MeshNetwork {
        
        do{
            
            if try meshNetworkManager.load(){
                // Mesh Network loaded from database
            }else{
                // No mesh network in database, we have to create one
                let meshNetwork = _generateMeshNetwork()
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "AppKey")
                _ = meshNetworkManager.save()
            }
            
            guard let _network = meshNetworkManager.meshNetwork else{
                throw(DoozMeshManagerApiError.errorLoadingMeshNetwork)
            }
            
            return _network
            
        }catch{
            throw(error)
        }
        
    }
    
    
    func _importMeshNetworkJson(_ json: String) throws{
        
        do{
            if let data = json.data(using: .utf8){
                let _network = try meshNetworkManager.import(from: data)
                
                if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork.id != _network.id) {
                    doozMeshNetwork = DoozMeshNetwork(messenger: messenger, network: _network)
                } else {
                    doozMeshNetwork?.meshNetwork = _network
                }
                
                let message: FlutterMessage =
                    [
                        EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkImported.rawValue,
                        EventSinkKeys.id.rawValue : _network.id
                    ]
                _sendFlutterMessage(message)
                
                #warning("save in db after import successful")
                //    delegate.onNetworkImported()
            }
            
        }catch{
            print("❌ Error importing json : \(error.localizedDescription)")
            throw(error)
        }
    }
    
    func _deleteMeshNetworkFromDb(_ id: String) throws{
        
        do{
            try doozStorage.delete()
        }catch{
            throw error
        }
        
    }
    
    func _exportMeshNetwork() -> String?{
        
        #warning("implement error management")
        
        let data = meshNetworkManager.export()
        let str = String(decoding: data, as: UTF8.self)
        
        if str != ""{
            return str
        }
        
        return nil
        
    }
    
    func _generateMeshNetwork() -> MeshNetwork{
        
        let meshUUID = UUID().uuidString
        let provisioner = Provisioner(name: UIDevice.current.name,
                                      allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
                                      allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
                                      allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
        
        let meshNetwork = meshNetworkManager.createNewMeshNetwork(withName: meshUUID, by: provisioner)
        
        return meshNetwork
    }
    
    func _resetMeshNetwork(){
        guard let _meshNetwork = meshNetworkManager.meshNetwork else{
            return
        }
        
        // Delete the existing network in local database and recreate a new / empty Mesh Network
        do{
            try _deleteMeshNetworkFromDb(_meshNetwork.id)
            let meshNetwork = _generateMeshNetwork()
            
            print("✅ Mesh Network successfully generated with name : \(meshNetwork.meshName)")
            
        }catch{
            print("❌ Error creating Mesh Network : \(error.localizedDescription)")
        }
        
    }
    
    func _didDeliverData(data: Data){
        
        guard
            let type = PduType(rawValue: UInt8(data[0])) else{
            return
        }
        
        let packet = data.subdata(in: 1 ..< data.count)
        
        switch type {
        case .provisioningPdu:
            doozProvisioningManager.didDeliverData(data, ofType: type)
            
        default:
            meshNetworkManager.bearerDidDeliverData(packet, ofType: type)
        }
        
    }
}

extension DoozMeshManagerApi: FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
}

extension DoozMeshManagerApi: DoozMeshManagerApiDelegate{
    
    func onNetworkLoaded(_ network: MeshNetwork) {
        
        if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork.id != network.id) {
            doozMeshNetwork = DoozMeshNetwork(messenger: messenger, network: network)
        } else {
            doozMeshNetwork?.meshNetwork = network
        }
        
        let message: FlutterMessage =
            [
                EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkLoaded.rawValue,
                EventSinkKeys.id.rawValue : network.id
            ]
        _sendFlutterMessage(message)
        
    }
    
    func onNetworkLoadFailed(_ error: Error) {
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkLoadFailed.rawValue,
            EventSinkKeys.error.rawValue : error
        ]
        
        _sendFlutterMessage(message)
        
    }
    
    func onNetworkUpdated(_ network: MeshNetwork) {
                
        doozMeshNetwork?.meshNetwork = network
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkUpdated.rawValue,
            EventSinkKeys.id.rawValue : network.id
        ]
        
        _sendFlutterMessage(message)
    }
    
    func onNetworkImported(_ network: MeshNetwork) {
                
        if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork.id != network.id) {
            doozMeshNetwork = DoozMeshNetwork(messenger: messenger, network: network)
        } else {
            doozMeshNetwork?.meshNetwork = network
        }
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkImported.rawValue,
            EventSinkKeys.id.rawValue : network.id
        ]
        
        _sendFlutterMessage(message)
        
    }
    
    func onNetworkImportFailed(_ error: Error) {
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkImportFailed.rawValue,
            EventSinkKeys.error.rawValue : error
        ] 
        
        _sendFlutterMessage(message)
    }
    
}


extension DoozMeshManagerApi: DoozProvisioningManagerDelegate{
    func provisioningBearerSendMessage(data: Data, bearer: DoozPBGattBearer) {
        
        let message: FlutterMessage = [
            
            EventSinkKeys.eventName.rawValue: ProvisioningEvent.sendProvisioningPdu.rawValue,
            EventSinkKeys.pdu.rawValue: data,
            EventSinkKeys.meshNode.meshNode.rawValue:[
                EventSinkKeys.meshNode.uuid.rawValue: bearer.identifier.uuidString
            ]
        ]
        
        _sendFlutterMessage(message)
        
    }
    
    func provisioningStateDidChange(unprovisionedDevice: UnprovisionedDevice, state: ProvisionigState) {
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : state.eventName(),
            EventSinkKeys.state.rawValue : state.flutterState(),
            EventSinkKeys.data.rawValue:[],
            EventSinkKeys.meshNode.meshNode.rawValue:[
                EventSinkKeys.meshNode.uuid.rawValue:unprovisionedDevice.uuid.uuidString
            ]
        ]
        
        _sendFlutterMessage(message)
    }
    
}



extension DoozMeshManagerApi: DoozPBGattBearerDelegate, DoozGattBearerDelegate, DoozTransmitterDelegate{
    func send(data: Data) {
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue: MessageEvent.onMeshPduCreated.rawValue,
            EventSinkKeys.pdu.rawValue: data
        ]
        
        _sendFlutterMessage(message)
        
    }
}


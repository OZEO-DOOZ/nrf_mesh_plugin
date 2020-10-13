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
    var meshNetworkManager: MeshNetworkManager?
    var delegate: DoozMeshManagerApiDelegate?
    
    var mtuSize: Int = -1
    
    //MARK: Private properties
    private var doozMeshNetwork: DoozMeshNetwork?
    private var eventSink: FlutterEventSink?
    private let messenger: FlutterBinaryMessenger
    private var doozStorage: LocalStorage?
    
    private var doozProvisioningManager: DoozProvisioningManager?
    private var doozTransmitter: DoozTransmitter?
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        
        super.init()
        
        self.delegate = self
        
        _initMeshNetworkManager()
        _initChannels(messenger: messenger)
        _initDoozProvisioningManager()
    }
    
}


private extension DoozMeshManagerApi {
    
    func _initMeshNetworkManager(){
        
        self.doozStorage = LocalStorage(fileName: DoozStorage.fileName)
        guard let _doozStorage = self.doozStorage else{
            return
        }
        
        meshNetworkManager = MeshNetworkManager(using: _doozStorage)
        meshNetworkManager?.logger = self
        
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        _meshNetworkManager.acknowledgmentTimerInterval = 0.150
        _meshNetworkManager.transmissionTimerInteral = 0.600
        _meshNetworkManager.incompleteMessageTimeout = 10.0
        _meshNetworkManager.retransmissionLimit = 2
        _meshNetworkManager.acknowledgmentMessageInterval = 4.2
        
        // As the interval has been increased, the timeout can be adjusted.
        // The acknowledged message will be repeated after 4.2 seconds,
        // 12.6 seconds (4.2 + 4.2 * 2), and 29.4 seconds (4.2 + 4.2 * 2 + 4.2 * 4).
        // Then, leave 10 seconds for until the incomplete message times out.
        _meshNetworkManager.acknowledgmentMessageTimeout = 40.0
        
        _meshNetworkManager.delegate = self
        
        self.doozTransmitter = DoozTransmitter()
        doozTransmitter?.doozDelegate = self
        _meshNetworkManager.transmitter = doozTransmitter
    }
    
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
    
    func _initDoozProvisioningManager(){
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        doozProvisioningManager = DoozProvisioningManager(meshNetworkManager: _meshNetworkManager, messenger: messenger, delegate: self)
    }
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [DoozMeshManagerApi] Received flutter call : \(call.method)")
        let _method = DoozMeshManagerApiChannel(call: call)
        
        switch _method {
        
        case .error(let error):
            print("❌ Plugin method - \(call.method) - isn't implemented")
            #warning("TODO : manage errors")
        //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
        
        case .loadMeshNetwork:
            #warning("Move loadMeshNetwork catch() logic here")
            _loadMeshNetwork()
            result(nil)
            
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
                try doozProvisioningManager?.identifyNode(data.uuid)
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
        case .provisioning:
            do{
                try doozProvisioningManager?.provision()
                result(nil)
            }catch{
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
            }
            
        case .handleNotifications(let data):
            
            #warning("❌ Tests required !")
            _didDeliverData(data: data.pdu)
            result(nil)
            
        // Old implementation in case this is not working with FlutterCallArguments
        //            if
        //                let _args = call.arguments as? [String:Any],
        //                let _pdu = _args["pdu"] as? FlutterStandardTypedData
        //            {
        //                self._didDeliverData(data: _pdu.data)
        //
        //            }
        
        case .setMtuSize(let data):
            
            delegate?.mtuSize = data.mtuSize
            result(nil)
            
        case .cleanProvisioningData:
            
            doozProvisioningManager?.cleanProvisioningData()
            result(nil)
            
        case .createMeshPduForConfigCompositionDataGet(let data):
            
            doozProvisioningManager?.createMeshPduForConfigCompositionDataGet(data.dest)
            result(nil)
            
        case .createMeshPduForConfigAppKeyAdd(let data):
            guard let appKey = meshNetworkManager?.meshNetwork?.applicationKeys.first else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: <#T##String#>, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            doozProvisioningManager?.createMeshPduForConfigAppKeyAdd(dest: data.dest, appKey: appKey)
            result(nil)
            
        case .sendGenericLevelSet(let data):
            #warning("TODO : add transitionTime and delay")
            
            guard let appKey = meshNetworkManager?.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: T##String, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            let message = GenericLevelSet(level: data.level)
            do{
                
                _ = try meshNetworkManager?.send(
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
            guard let appKey = meshNetworkManager?.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                result(nil)
                #warning("TODO : manage errors")
                //throw FlutterError(code: T##String, message: <#T##String?#>, details: <#T##Any?#>)
                //result(FlutterMethodNotImplemented)
                return
            }
            
            
            let message = GenericOnOffSet(data.value)
            
            do{
                _ = try meshNetworkManager?.send(
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
                let group = meshNetworkManager?.meshNetwork?.group(withAddress: MeshAddress(Address(bitPattern: data.subscriptionAddress))),
                
                let node = meshNetworkManager?.meshNetwork?.node(withAddress: Address(bitPattern: data.address)),
                let element = node.element(withAddress: Address(bitPattern: data.elementAddress)),
                let model = element.model(withModelId: data.modelIdentifier){
                
                let message: ConfigMessage =
                    ConfigModelSubscriptionAdd(group: group, to: model) ??
                    ConfigModelSubscriptionVirtualAddressAdd(group: group, to: model)!
                
                do{
                    _ = try meshNetworkManager?.send(message, to: model)
                    result(true)
                }catch{
                    print(error)
                    result(nil)
                }
            }
            
        case .sendConfigModelSubscriptionDelete(let data):
            #warning("❌ TO TEST")
            
            if
                let group = meshNetworkManager?.meshNetwork?.group(withAddress: MeshAddress(Address(bitPattern: data.subscriptionAddress))),
                
                let node = meshNetworkManager?.meshNetwork?.node(withAddress: Address(bitPattern: data.address)),
                let element = node.element(withAddress: Address(bitPattern: data.elementAddress)),
                let model = element.model(withModelId: data.modelIdentifier){
                
                let message: ConfigMessage =
                    ConfigModelSubscriptionDelete(group: group, from: model) ??
                    ConfigModelSubscriptionVirtualAddressDelete(group: group, from: model)!
                
                do{
                    _ = try meshNetworkManager?.send(message, to: model)
                    result(true)
                }catch{
                    print(error)
                    result(nil)
                }
            }
            
        case .sendConfigModelAppBind(let data):
            do{
                let node = meshNetworkManager?.meshNetwork?.node(withAddress: Address(bitPattern: data.nodeId))
                let element = node?.element(withAddress: Address(bitPattern: data.elementId))
                let model = element?.model(withModelId: data.modelId)
                let appKey = meshNetworkManager?.meshNetwork?.applicationKeys[KeyIndex(data.appKeyIndex)]
                
                if let _appKey = appKey, let _model = model{
                    
                    if let configModelAppBind = ConfigModelAppBind(applicationKey: _appKey, to: _model){
                        try _ =  meshNetworkManager?.send(configModelAppBind, to: _model)
                        result(nil)
                    }
                }
                
            }catch{
                print(error)
            }
            
        case .getSequenceNumberForAddress(let data):
            #warning("check if only one node ?")
            if
                let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(bitPattern: data.address)),
                _node.elementsCount > 0{
                
                let sequenceNumber = meshNetworkManager?.getSequenceNumber(ofLocalElement: _node.elements[0])
                result(sequenceNumber)
                
            }else{
                result(nil)
            }
            
        }
        
    }
    
}


private extension DoozMeshManagerApi{
    
    func _loadMeshNetwork(){
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        do{
            
            if try _meshNetworkManager.load(){
                // Mesh Network loaded from database
                let element0 = Element(name: "Primary Element", location: .first, models: [
                    // 4 generic models defined by Bluetooth SIG:
                    Model(sigModelId: 0x1000, delegate: GenericOnOffServerDelegate()),
                    Model(sigModelId: 0x1002, delegate: GenericLevelServerDelegate()),
                    Model(sigModelId: 0x1001, delegate: GenericOnOffClientDelegate()),
                    Model(sigModelId: 0x1003, delegate: GenericLevelClientDelegate()),
                ])
                
                _meshNetworkManager.localElements = [element0]
            }else{
                // No mesh network in database, we have to create one
                let meshNetwork = try _generateMeshNetwork()
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "AppKey")
            }
            
            guard let _network = _meshNetworkManager.meshNetwork else{
                delegate?.onNetworkLoadFailed(DoozMeshManagerApiError.errorLoadingMeshNetwork)
                return
            }
            
            delegate?.onNetworkLoaded(_network)
            
        }catch{
            delegate?.onNetworkLoadFailed(error)
        }
        
    }
    
    
    func _importMeshNetworkJson(_ json: String) throws{
        
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        do{
            if let data = json.data(using: .utf8){
                let _network = try _meshNetworkManager.import(from: data)
                
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
        
        // We have to implement the reset / delete logic on plugin side.
        // See https://github.com/NordicSemiconductor/IOS-nRF-Mesh-Library/issues/279
        
        guard let _doozStorage = self.doozStorage else{
            throw DoozMeshManagerApiError.doozStorageNotFound
        }
        
        do{
            try _doozStorage.delete()
        }catch{
            throw error
        }
        
    }
    
    func _exportMeshNetwork() -> String?{
        
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return nil
        }
        
        let data = _meshNetworkManager.export()
        let str = String(decoding: data, as: UTF8.self)
        
        if str != ""{
            return str
        }
        
        return nil
        
    }
    
    func _generateMeshNetwork() throws -> MeshNetwork{
        
        guard let _meshNetworkManager = self.meshNetworkManager else{
            throw DoozMeshManagerApiError.meshManagerApiNotInitialized
        }
        
        let meshUUID = UUID().uuidString
        let provisioner = Provisioner(name: UIDevice.current.name,
                                      allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
                                      allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
                                      allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
        
        let meshNetwork = _meshNetworkManager.createNewMeshNetwork(withName: meshUUID, by: provisioner)
        _ = _meshNetworkManager.save()
        
        return meshNetwork
    }
    
    func _resetMeshNetwork(){
        guard let _meshNetwork = self.meshNetworkManager?.meshNetwork else{
            return
        }
        
        // Delete the existing network in local database and recreate a new / empty Mesh Network
        do{
            try _deleteMeshNetworkFromDb(_meshNetwork.id)
            let meshNetwork = try _generateMeshNetwork()
            
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
            guard let _doozProvisioningManager = self.doozProvisioningManager else{
                return
            }
            
            _doozProvisioningManager.didDeliverData(data, ofType: type)
            
        default:
            guard let _meshNetworkManager = self.meshNetworkManager else{
                return
            }
            
            _meshNetworkManager.bearerDidDeliverData(packet, ofType: type)
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
        print("✅ Mesh Network loaded from database")
        
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
        print("❌ Error loading Mesh Network : \(error.localizedDescription)")
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkLoadFailed.rawValue,
            EventSinkKeys.error.rawValue : error
        ]
        
        _sendFlutterMessage(message)
        
    }
    
    func onNetworkUpdated(_ network: MeshNetwork) {
        
        print("✅ Mesh Network updated")
        
        doozMeshNetwork?.meshNetwork = network
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkUpdated.rawValue,
            EventSinkKeys.id.rawValue : network.id
        ]
        
        _sendFlutterMessage(message)
    }
    
    func onNetworkImported(_ network: MeshNetwork) {
        
        print("✅ Mesh Network imported")
        
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
        print("❌ Error importing Mesh Network : \(error.localizedDescription)")
        
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


extension DoozMeshManagerApi: MeshNetworkDelegate{
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        print("📣 didReceiveMessage : \(message) from \(source) to \(destination)")
        
        // Handle the message based on its type.
        switch message {
        
        case let status as ConfigModelAppStatus:
            
            if status.isSuccess {
                let message: FlutterMessage = [
                    
                    EventSinkKeys.eventName.rawValue: MessageEvent.onConfigModelAppStatus.rawValue,
                    EventSinkKeys.message.elementAddress.rawValue: status.elementAddress,
                    EventSinkKeys.message.modelId.rawValue: status.modelId,
                    EventSinkKeys.message.appKeyIndex.rawValue: status.applicationKeyIndex,
                    
                ]
                
                _sendFlutterMessage(message)
                
            } else {
                break
            }
            
        case is ConfigCompositionDataStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigCompositionDataStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.meshMessage.rawValue : [
                    EventSinkKeys.message.source.rawValue : source,
                    EventSinkKeys.message.destination.rawValue : destination
                ]
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigAppKeyStatus:
            if status.isSuccess {
                let message: FlutterMessage = [
                    
                    EventSinkKeys.eventName.rawValue : MessageEvent.onConfigAppKeyStatus.rawValue,
                    EventSinkKeys.source.rawValue : source,
                    EventSinkKeys.message.meshMessage.rawValue : [
                        EventSinkKeys.message.source.rawValue : source,
                        EventSinkKeys.message.destination.rawValue : destination
                    ]
                    
                ]
                
                _sendFlutterMessage(message)
            }else {
                break
            }
            
        case let status as GenericLevelStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onGenericLevelStatus.rawValue,
                EventSinkKeys.level.rawValue : status.level,
                EventSinkKeys.targetLevel.rawValue : status.targetLevel ?? 0,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination
                
            ]
            
            _sendFlutterMessage(message)
            
            
        //        case let list as ConfigModelAppList:
        //            break
        //
        //        case let list as ConfigModelSubscriptionList:
        //            break
        //
        //        case let status as ConfigModelPublicationStatus:
        //            break
        //
        //        case let status as ConfigModelSubscriptionStatus:
        //            break
        
        default:
            break
        }
        
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didSendMessage message: MeshMessage, from localElement: Element, to destination: Address) {
        print("📣 didSendMessage : \(message) from \(localElement) to \(destination)")
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, failedToSendMessage message: MeshMessage, from localElement: Element, to destination: Address, error: Error) {
        print("📣 failedToSendMessage : \(message) from \(localElement) to \(destination) : \(error)")
    }
    
}

extension DoozMeshManagerApi: DoozPBGattBearerDelegate, DoozGattBearerDelegate, DoozTransmitterDelegate{
    func send(data: Data) {
        
        let dict: [String : Any] = [
            
            EventSinkKeys.eventName.rawValue: MessageEvent.onMeshPduCreated.rawValue,
            EventSinkKeys.pdu.rawValue: data
        ]
        
        _sendFlutterMessage(dict)
        
    }
}

// MARK: FlutterMessages 

private extension DoozMeshManagerApi {
    typealias FlutterMessage = [String : Any]
    
    func _sendFlutterMessage(_ message: FlutterMessage) {
        guard let _eventSink = self.eventSink else {
            return
        }
        
        _eventSink(message)
    }
}


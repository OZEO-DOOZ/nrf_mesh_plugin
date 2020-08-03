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
    private var messenger: FlutterBinaryMessenger?
    private var doozStorage: LocalStorage?
    
    private var doozProvisioningManager: DoozProvisioningManager?
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        
        self.messenger = messenger
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
        guard let _meshNetworkManager = self.meshNetworkManager, let _messenger = self.messenger else{
            return
        }
        
        doozProvisioningManager = DoozProvisioningManager(meshNetworkManager: _meshNetworkManager, messenger: _messenger, delegate: self)
    }
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [DoozMeshManagerApi] Received flutter call : \(call.method)")
        guard let _method = DoozMeshManagerApiChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
            
        case .loadMeshNetwork:
            _loadMeshNetwork()
            result(nil)
            break
        case .importMeshNetworkJson:
            if let _args = call.arguments as? [String:Any], let _json = _args["json"] as? String{
                _importMeshNetworkJson(_json)
            }
            result(nil)
            break
        case .deleteMeshNetworkFromDb:
            if let _args = call.arguments as? [String:Any], let _id = _args["id"] as? String{
                
                do{
                    try _deleteMeshNetworkFromDb(_id)
                }catch{
                    #warning("TODO: Manage errors on delete")
                }
                
            }
            break
        case .exportMeshNetwork:
            if let json = _exportMeshNetwork(){
                result(json)
            }
            break
        case .identifyNode:
            
            if
                let _doozProvisioningManager = self.doozProvisioningManager,
                let _args = call.arguments as? [String:Any],
                let _strServiceUUID = _args["serviceUuid"] as? String,
                let _serviceUUID = UUID(uuidString: _strServiceUUID)
            {
                _doozProvisioningManager.identifyNode(_serviceUUID)
            }
            
            result(nil)
            
            break
            
        case .provisioning:
            if let _doozProvisioningManager = self.doozProvisioningManager{
                _doozProvisioningManager.provision()
            }
            
            
            result(nil)
            
            break
            
        case .getDeviceUuid:
            
            if let _args = call.arguments as? [String:Any], let _serviceData = _args["serviceData"] as? String{
                #warning("to implement")
                //result.success(mMeshManagerApi.getDeviceUuid(serviceData).toString());
                
            }
            break
            
        case .handleNotifications:
            print(call.arguments)
            if
                let _doozProvisioningManager = self.doozProvisioningManager,
                let _args = call.arguments as? [String:Any],
                let _flutterPdu = _args["pdu"] as? FlutterStandardTypedData
            {

                _doozProvisioningManager.didDeliverData(data: _flutterPdu.data)
                
            }
            
            result(nil)
            
            break
            
        case .handleWriteCallbacks:
            // Does not exists in iOS ?
            #warning("useless in ios ?")
            if
                let _doozProvisioningManager = self.doozProvisioningManager,
                let _args = call.arguments as? [String:Any],
                let _pdu = _args["pdu"] as? [Int]
            {

                //_doozProvisioningManager.didDeliverData(data: _pdu)

            }
            
            result(nil)
            
            break
            
        case .setMtuSize:
            
            if let _args = call.arguments as? [String:Any], let _mtuSize = _args["mtuSize"] as? Int{
                #warning("useless in ios ?")
                delegate?.mtuSize = _mtuSize
                result(nil)
            }
            break
            
        case .cleanProvisioningData:
            if
                let _doozProvisioningManager = self.doozProvisioningManager{
                _doozProvisioningManager.cleanProvisioningData()
                result(nil)
            }
            
        }
        
    }
    
}


private extension DoozMeshManagerApi{
    // Events native implementations
    
    func _loadMeshNetwork(){
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        do{
            
            if try _meshNetworkManager.load(){
                // Mesh Network loaded from database
            }else{
                // No mesh network in database, we have to create one
                print("✅ No Mesh Network in database, creating a new one...")
                
                let meshNetwork = try _generateMeshNetwork()
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "AppKey")
                
                
                print("✅ Mesh Network successfully generated with name : \(meshNetwork.meshName)")
                
            }
            
            delegate?.onNetworkLoaded(_meshNetworkManager.meshNetwork)
            
        }catch{
            delegate?.onNetworkLoadFailed(error)
        }
        
    }
    
    
    func _importMeshNetworkJson(_ json: String){
        
        guard let _messenger = self.messenger, let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        
        do{
            if let data = json.data(using: .utf8){
                let _network = try _meshNetworkManager.import(from: data)
                
                print("✅ Json imported")
                
                if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork?.id != _network.id) {
                    doozMeshNetwork = DoozMeshNetwork(messenger: _messenger, network: _network)
                } else {
                    doozMeshNetwork?.meshNetwork = _network
                }
                
                if let _eventSink = self.eventSink{
                    // Inform Flutter that a network was imported
                    _eventSink(
                        [
                            EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkImported.rawValue,
                            EventSinkKeys.id : _network.id
                    ])
                }
                #warning("save in db after import successful")
                //    delegate.onNetworkImported()
            }
            
        }catch{
            print("❌ Error importing json : \(error.localizedDescription)")
            // delegate.onNetworkImportFailed()
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
    
    
    func onNetworkLoaded(_ network: MeshNetwork?) {
        print("✅ Mesh Network loaded from database")
        
        guard
            let _network = network,
            let _messenger = self.messenger,
            let _eventSink = self.eventSink
            else{
                return
        }
        
        if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork?.id != _network.id) {
            doozMeshNetwork = DoozMeshNetwork(messenger: _messenger, network: _network)
        } else {
            doozMeshNetwork?.meshNetwork = _network
        }
        
        _eventSink(
            [
                EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkLoaded.rawValue,
                EventSinkKeys.id : _network.id
            ]
        )
        
    }
    
    func onNetworkLoadFailed(_ error: Error) {
        print("❌ Error loading Mesh Network : \(error.localizedDescription)")
        
        guard let _eventSink = self.eventSink else{
            return
        }
        
        _eventSink(
            [
                EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkLoadFailed.rawValue,
                EventSinkKeys.error : error
            ]
        )
        
    }
    
    func onNetworkUpdated(_ network: MeshNetwork?) {
        
        print("✅ Mesh Network updated")
        
        guard
            let _network = network,
            let _eventSink = self.eventSink
            else{
                return
        }
        
        doozMeshNetwork?.meshNetwork = _network
        
        _eventSink(
            [
                EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkUpdated.rawValue,
                EventSinkKeys.id : _network.id
            ]
        )
    }
    
    func onNetworkImported(_ network: MeshNetwork?) {
        
        print("✅ Mesh Network imported")
        
        guard
            let _network = network,
            let _messenger = self.messenger,
            let _eventSink = self.eventSink
            else{
                return
        }
        
        if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork?.id != _network.id) {
            doozMeshNetwork = DoozMeshNetwork(messenger: _messenger, network: _network)
        } else {
            doozMeshNetwork?.meshNetwork = _network
        }
        
        _eventSink(
            [
                EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkImported.rawValue,
                EventSinkKeys.id : _network.id
            ]
        )
        
    }
    
    func onNetworkImportFailed(_ error: Error) {
        print("❌ Error importing Mesh Network : \(error.localizedDescription)")
        
        guard let _eventSink = self.eventSink else{
            return
        }
        
        _eventSink(
            [
                EventSinkKeys.eventName : MeshNetworkApiEvent.onNetworkImportFailed.rawValue,
                EventSinkKeys.error : error
            ]
        )
    }
    
    
}




extension DoozMeshManagerApi: DoozMeshProvisioningStatusDelegate{
    
}

extension DoozMeshManagerApi: LoggerDelegate{
    func log(message: String, ofCategory category: LogCategory, withLevel level: LogLevel) {
        print("[\(String(describing: self.classForCoder))] \(message)")
    }
    
    
}

extension DoozMeshManagerApi: DoozProvisioningManagerDelegate{
    func provisioningStateDidChange(device: UnprovisionedDevice, state: ProvisionigState, eventSinkMessage: Dictionary<String, Any>){
        if let _eventSink = self.eventSink{
            _eventSink(eventSinkMessage)
        }
    }
    
    func sendMessage(_ msg: Dictionary<String, Any>) {
        if let _eventSink = self.eventSink{
            _eventSink(msg)
        }
    }
    
    func didFinishProvisioning() {
        if let _eventSink = self.eventSink{
            _eventSink(
                [
                    EventSinkKeys.eventName : ProvisioningEvent.onConfigAppKeyStatus.rawValue
            ])
        }
    }
    
}

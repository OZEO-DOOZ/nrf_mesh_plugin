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
    
    private var provisioningManager: ProvisioningManager?
    private var unprovisionedDevices = [DoozUnprovisionedDevice]()
    
    private var unprovisionedDevice: UnprovisionedDevice?
    
    private var provisioningBearer: PBGattBearer?
    
    #warning("refacto proper")
    private var compositionDataGetNeeded = false
    private var node: Node?
    
    private var testGattBearer: GattBearer?
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        
        self.messenger = messenger
        self.delegate = self
        
        _initMeshNetworkManager()
        _initChannels(messenger: messenger)
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
        
        _meshNetworkManager.delegate = self
        
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
                let _args = call.arguments as? [String:Any],
                let _strServiceUUID = _args["serviceUuid"] as? String,
                let _serviceUUID = UUID(uuidString: _strServiceUUID)
            {
                do{
                    self.provisioningBearer = PBGattBearer(targetWithIdentifier: _serviceUUID)
                    if let _bearer = self.provisioningBearer{
                        self.unprovisionedDevice = UnprovisionedDevice(uuid: _serviceUUID)
                        
                        if let _unprovisionedDevice = self.unprovisionedDevice{
                            self.provisioningManager = try meshNetworkManager?.provision(unprovisionedDevice: _unprovisionedDevice, over: _bearer)
                            
                            self.provisioningManager?.logger = self
                            _bearer.delegate = self
                            _bearer.open()
                        }
                    }
                    
                    
                    
                }catch{
                    print(error)
                }
                
                result(nil)
            }
            break
            
        case .provisioning:
            
            if let _provisioningManager = self.provisioningManager{
                do{
                    try _provisioningManager.provision(
                        usingAlgorithm: .fipsP256EllipticCurve,
                        publicKey: .noOobPublicKey,
                        authenticationMethod: .noOob)
                    
                }catch{
                    print(error)
                }
                
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
            if let _args = call.arguments as? [String:Any], let _pdu = _args["pdu"] as? String{
                #warning("to implement")
                
                //handleNotifications(call.argument<Int>("mtu")!!, pdu)
                result(nil)
            }
            break
            
        case .handleWriteCallbacks:
            
            if let _args = call.arguments as? [String:Any], let _pdu = _args["pdu"] as? String{
                #warning("to implement")
                
                //handleWriteCallbacks(call.argument<Int>("mtu")!!, pdu);
                result(nil)
            }
            break
            
        case .setMtuSize:
            
            if let _args = call.arguments as? [String:Any], let _mtuSize = _args["mtuSize"] as? Int{
                #warning("to test")
                delegate?.mtuSize = _mtuSize
                result(nil)
            }
            break
            
            
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
        //        if let _storage =
        //        delete()
        do{
            try _deleteMeshNetworkFromDb(_meshNetwork.id)
            let meshNetwork = try _generateMeshNetwork()
            
            print("✅ Mesh Network successfully generated with name : \(meshNetwork.meshName)")
            
        }catch{
            print("❌ Error creating Mesh Network : \(error.localizedDescription)")
        }
        
    }
    
}


extension DoozMeshManagerApi: MeshNetworkDelegate{
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        print("📣 didReceiveMessage : \(message) from \(source) to \(destination)")
        
        switch message {
            
        case is ConfigCompositionDataStatus:
            self.getTtl()
            
        case is ConfigDefaultTtlStatus:
            self.sendAppKey()
                
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

private extension ProvisionigState{
    
    func eventName() -> String{
        switch self {
            
        case .complete:
            return ProvisioningEvent.onProvisioningCompleted.rawValue
        case .fail(_):
            return ProvisioningEvent.onProvisioningFailed.rawValue
        default:
            return ProvisioningEvent.onProvisioningStateChanged.rawValue
            
        }
    }
    func flutterState() -> String {
        switch self {
            
        case .capabilitiesReceived(_):
            return "PROVISIONING_CAPABILITIES"
        case .ready:
            return "PROVISIONER_READY"
        case .requestingCapabilities:
            return "REQUESTING_CAPABILITIES"
        case .provisioning:
            return "PROVISIONING"
        default:
            return ""
            
        }
    }
    
}

extension DoozMeshManagerApi: ProvisioningDelegate{
    
    func provisioningState(of unprovisionedDevice: UnprovisionedDevice, didChangeTo state: ProvisionigState) {
                
        if let _messenger = self.messenger{
            if !(unprovisionedDevices.contains(where: { $0.unprovisionedDevice?.uuid == unprovisionedDevice.uuid })) {
                unprovisionedDevices.append(DoozUnprovisionedDevice(messenger: _messenger, unprovisionedMeshNode: unprovisionedDevice))
            }
        }
        
        switch state {
        case .complete:
            if let _bearer = self.provisioningBearer{
                _bearer.close()
            }
        default:
            break
        }
        if let _eventSink = self.eventSink{
            
            _eventSink(
                [
                    EventSinkKeys.eventName : state.eventName(),
                    EventSinkKeys.state : state.flutterState(),
                    "data":[],
                    "meshNode":[
                        "uuid":unprovisionedDevice.uuid.uuidString
                    ]
            ])
            
        }
        
    }
    
    func authenticationActionRequired(_ action: AuthAction) { }
    
    func inputComplete() { }
}

extension DoozMeshManagerApi: BearerDelegate{
    func bearerDidOpen(_ bearer: Bearer) {
        print("bearerDidOpen")
        
        guard !compositionDataGetNeeded else{
            compositionDataGet()
            return
        }
        
        if let _provisioningManager = self.provisioningManager{
            _provisioningManager.delegate = self
            let attentionTimer: UInt8 = 5
            
            do{
                try _provisioningManager.identify(andAttractFor: attentionTimer)
            }
            catch{
                bearer.close()
                print(error)
            }
            
        }
    }
    
    func bearer(_ bearer: Bearer, didClose error: Error?) {
        guard let _provisioningManager = self.provisioningManager, case .complete = _provisioningManager.state else {
            print("Device disconnected")
            return
        }
        print("Provisioning complete")
        
        #warning("WIP, rename and find better way to do it")
        compositionDataGetNeeded = true
        
        if let _meshNetworkManager = self.meshNetworkManager{
            if _meshNetworkManager.save(), let _unprovisionedDevice = self.unprovisionedDevice{
                if let _meshNetwork = _meshNetworkManager.meshNetwork, let _node = _meshNetwork.node(for: _unprovisionedDevice){
                    _meshNetworkManager.localElements = []
                    provisionerDidProvisionNewDevice(_node)
                    
                }
            }else {
                print("Mesh configuration could not be saved.")
            }

        }
        
        //        guard !compositionDataGetNeeded else{
        
        
        return
    }
    //}
    
    func provisionerDidProvisionNewDevice(_ node: Node){
        if let _meshNetworkManager = self.meshNetworkManager{
            let localProvisioner = _meshNetworkManager.meshNetwork?.localProvisioner
            guard localProvisioner?.hasConfigurationCapabilities ?? false else {
                // The Provisioner cannot sent or receive messages.
                
                return
            }
            
            self.node = node
            
            do{
                
                self.testGattBearer = GattBearer(targetWithIdentifier: unprovisionedDevice!.uuid)
                
                if let _gattBearer = testGattBearer{
                    _gattBearer.delegate = self
                    _gattBearer.logger = self
                    _gattBearer.open()
                    _gattBearer.dataDelegate = _meshNetworkManager
                    
                    _meshNetworkManager.transmitter = _gattBearer
                    _meshNetworkManager.delegate = self
//                    node.name = "toto"
//                    let messageHandle = try _meshNetworkManager.send(message, to: node)
                    
                }
                
                
            }catch{
                print("Error getting composition data")
            }
        }
        
        
        
        
    }
    
    func getTtl(){
        let message = ConfigDefaultTtlGet()

        
        if let _node = self.node,
            let _meshNetworkManager = self.meshNetworkManager{
            
            _node.name = "toto"
            
            do{
                print("📩 Sending message : ConfigCompositionDataGet")
                let messageHandle = try _meshNetworkManager.send(message, to: _node)
                compositionDataGetNeeded = false

            }catch{
                print(error)
            }
            
        }
    }
    
    func sendAppKey(){
        if let _meshNetworkManager = self.meshNetworkManager, let _node = self.node{
            do{
                try _meshNetworkManager.meshNetwork?.add(applicationKey: Data.random128BitKey(), name: "appKeyTest")
                
                if let _appKey = _meshNetworkManager.meshNetwork?.applicationKeys.first{
                    try _meshNetworkManager.send(ConfigAppKeyAdd(applicationKey: _appKey), to: _node)
                    print("💪 SEND APP KEY")
                }
            }catch{
                print(error)
            }
            
        }
        
    }
    
    func compositionDataGet(){
        let message = ConfigCompositionDataGet()

        if let _node = self.node,
            let _meshNetworkManager = self.meshNetworkManager{
            
            _node.name = "toto"
            
            do{
                print("📩 Sending message : ConfigCompositionDataGet")
                let messageHandle = try _meshNetworkManager.send(message, to: _node)
                compositionDataGetNeeded = false

            }catch{
                print(error)
            }
            
        }
    }
    
}


extension DoozMeshManagerApi: DoozMeshProvisioningStatusDelegate{
    
}

extension DoozMeshManagerApi: LoggerDelegate{
    func log(message: String, ofCategory category: LogCategory, withLevel level: LogLevel) {
        print("[LOGGER] \(message)")
    }
    
    
}

extension DoozMeshManagerApi: GattBearerDelegate{
    func bearerDidConnect(_ bearer: Bearer) {
        print("✅ CONNECTED TO BEARER")
    }
}

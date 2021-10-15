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
        self.meshNetworkManager.transmissionTimerInterval = 0.600
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
            case FlutterCallError.missingArguments:
                result(FlutterError(code: "missingArguments", message: "The provided arguments does not match required", details: nil))
            case FlutterCallError.errorDecoding:
                result(FlutterError(code: "errorDecoding", message: "An error occured attempting to decode arguments", details: nil))
            default:
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
        
            break
        case .loadMeshNetwork:
            do {
                let network = try _loadMeshNetwork()                
                // Set up local Elements on the phone.
                let element0 = Element(name: "Primary Element", location: .first, models: [
                    Model(sigModelId: 0x1000, delegate: GenericOnOffServerDelegate()),
                    Model(sigModelId: 0x1002, delegate: GenericLevelServerDelegate()),
                    Model(sigModelId: 0x1001, delegate: GenericOnOffClientDelegate()),
                    Model(sigModelId: 0x1003, delegate: GenericLevelClientDelegate())
                ])
                meshNetworkManager.localElements = [element0]
                delegate?.onNetworkLoaded(network)
                delegate?.onNetworkUpdated(network)
                result(nil)
            }catch {
                delegate?.onNetworkLoadFailed(error)
            }
            
        case .importMeshNetworkJson(let data):
            do{
                let network = try _importMeshNetworkJson(data.json)
                // Set up local Elements on the phone.
                 let element0 = Element(name: "Primary Element", location: .first, models: [
                     Model(sigModelId: 0x1000, delegate: GenericOnOffServerDelegate()),
                     Model(sigModelId: 0x1002, delegate: GenericLevelServerDelegate()),
                     Model(sigModelId: 0x1001, delegate: GenericOnOffClientDelegate()),
                     Model(sigModelId: 0x1003, delegate: GenericLevelClientDelegate())
                 ])
                 meshNetworkManager.localElements = [element0]

                delegate?.onNetworkImported(network)
                delegate?.onNetworkUpdated(network)
                result(nil)
            }catch{
                delegate?.onNetworkImportFailed(error)
            }
            
        case .deleteMeshNetworkFromDb(let data):
            do{
                try _deleteMeshNetworkFromDb(data.id)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            
        case .exportMeshNetwork:
            let json = _exportMeshNetwork()
            result(json)
            break
        case .resetMeshNetwork:
            do {
                try _resetMeshNetwork()
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
           
            break
        case .identifyNode(var data):
            do{
                try doozProvisioningManager.identifyNode(data.uuid)
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .provisioning:
            do{
                try doozProvisioningManager.provision()
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .handleNotifications(let data):
            
            _didDeliverData(data: data.pdu.data)
            result(nil)
            break
        case .setMtuSize(let data):
            
            delegate?.mtuSize = data.mtuSize
            result(nil)
            break
        case .cleanProvisioningData:
            
            doozProvisioningManager.cleanProvisioningData()
            result(nil)
            break
        case .sendConfigCompositionDataGet(let data):
            
            doozProvisioningManager.sendConfigCompositionDataGet(data.dest)
            result(nil)
            break
        case .sendConfigAppKeyAdd(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys.first else{
                let error = MeshNetworkError.noApplicationKey
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            
            doozProvisioningManager.sendConfigAppKeyAdd(dest: data.dest, appKey: appKey)
            result(nil)
            break
        case .sendGenericLevelSet(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            
            let stepResolution = StepResolution(rawValue: UInt8(data.transitionResolution))!
            let transitionTime = TransitionTime(steps: UInt8(data.transitionStep), stepResolution: stepResolution)
            
            let message = GenericLevelSet(level: Int16(data.level), transitionTime: transitionTime, delay: UInt8(data.delay))
            do{
                
                _ = try meshNetworkManager.send(
                    message,
                    to: MeshAddress(Address(exactly: data.address)!),
                    using: appKey
                )
                
                result(nil)
                
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
            
        case .sendGenericOnOffSet(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            
            let stepResolution = StepResolution(rawValue: UInt8(data.transitionResolution))!
            let transitionTime = TransitionTime(steps: UInt8(data.transitionStep), stepResolution: stepResolution)
            
            let message = GenericOnOffSet(data.value, transitionTime: transitionTime, delay: UInt8(data.delay))
            
            do{
                _ = try meshNetworkManager.send(
                    message,
                    to: MeshAddress(Address(exactly: data.address)!),
                    using: appKey
                )
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendConfigModelSubscriptionAdd(let data):
            if
                let group = meshNetworkManager.meshNetwork?.group(withAddress: MeshAddress(Address(exactly: data.subscriptionAddress)!)),
                
                    let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(exactly: data.elementAddress)!),
                let element = node.element(withAddress: Address(exactly: data.elementAddress)!),
                let model = element.model(withModelId: UInt32(data.modelIdentifier)){

                let message: ConfigMessage =
                    ConfigModelSubscriptionAdd(group: group, to: model) ??
                    ConfigModelSubscriptionVirtualAddressAdd(group: group, to: model)!
                
                do{
                    _ = try meshNetworkManager.send(message, to: node)
                    result(true)
                }catch{
                    let nsError = error as NSError
                    result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                }
            }
            break
        case .sendConfigModelSubscriptionDelete(let data):
            if
                let group = meshNetworkManager.meshNetwork?.group(withAddress: MeshAddress(Address(exactly: data.subscriptionAddress)!)),
                
                    let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(exactly: data.address)!),
                let element = node.element(withAddress: Address(exactly: data.elementAddress)!),
                let model = element.model(withModelId: UInt32(data.modelIdentifier)){
                
                let message: ConfigMessage =
                    ConfigModelSubscriptionDelete(group: group, from: model) ??
                    ConfigModelSubscriptionVirtualAddressDelete(group: group, from: model)!
                
                do{
                    _ = try meshNetworkManager.send(message, to: node)
                    result(true)
                }catch{
                    let nsError = error as NSError
                    result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                }
            }
            break
        case .sendConfigModelAppBind(let data):
            do{
                let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(exactly: data.nodeId)!)
                let element = node?.element(withAddress: Address(exactly: data.elementId)!)
                let model = element?.model(withModelId: UInt32(data.modelId))
                let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.appKeyIndex)]
                
                if let _appKey = appKey, let _model = model{
                    
                    if let configModelAppBind = ConfigModelAppBind(applicationKey: _appKey, to: _model){
                        try _ =  meshNetworkManager.send(configModelAppBind, to: node!)
                        result(nil)
                    }
                }
                
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .getSequenceNumberForAddress(let data):
            if
                let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(bitPattern: data.address)),
                _node.elements.count == 1,
                let element = _node.elements.first {
                
                let sequenceNumber = meshNetworkManager.getSequenceNumber(ofLocalElement: element)
                result(sequenceNumber)
                
            }else{
                let error = AccessError.invalidElement
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .setSequenceNumberForAddress(let data):
            if
                let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(bitPattern: data.address)),
                _node.elements.count == 1,
                let element = _node.elements.first {
                meshNetworkManager.setSequenceNumber(data.sequenceNumber, forLocalElement: element)
                result(nil)

            }else{
                let error = AccessError.invalidElement
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendGenericLevelGet(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            
            let message = GenericLevelGet()
            do{
                
                _ = try meshNetworkManager.send(
                    message,
                    to: MeshAddress(Address(exactly: data.address)!),
                    using: appKey
                )
                
                result(nil)
                
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .setNetworkTransmitSettings(let data):
            let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(exactly: data.address)!)
            let message = ConfigNetworkTransmitSet(count: UInt8(data.transmitCount), steps: UInt8(data.transmitIntervalSteps))
            do {
                _ = try meshNetworkManager.send(message, to: _node!)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .getNetworkTransmitSettings(let data):
            let message = ConfigNetworkTransmitGet()
            let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(exactly: data.address)!)
            do {
                _ = try meshNetworkManager.send(message, to: _node!)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .getDefaultTtl(let data):
            let message = ConfigDefaultTtlGet()
            let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(exactly: data.address)!)
            do {
                _ = try meshNetworkManager.send(message, to: _node!)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .setDefaultTtl(let data):
            let message = ConfigDefaultTtlSet(ttl: UInt8(data.ttl))
            let _node = doozMeshNetwork?.meshNetwork.node(withAddress: Address(exactly: data.address)!)
            do {
                _ = try meshNetworkManager.send(message, to: _node!)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendConfigModelSubscriptionDeleteAll(let data):
            if
                
                let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(exactly: data.elementAddress)!),
                let element = node.element(withAddress: Address(exactly: data.elementAddress)!),
                let model = element.model(withModelId: UInt32(data.modelIdentifier)){
                
                let message: ConfigMessage = ConfigModelSubscriptionDeleteAll(from: model)!
                do {
                    _ = try meshNetworkManager.send(message, to: node)
                    result(nil)
                } catch {
                    let nsError = error as NSError
                    result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                }
            }
            break
        case .sendConfigModelPublicationSet(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.appKeyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            let retransmit = Publish.Retransmit.init(publishRetransmitCount: UInt8(data.retransmitCount), intervalSteps: UInt8(data.retransmitIntervalSteps))
            let stepResolution = StepResolution.init(rawValue: UInt8(data.publicationResolution))
            let period = Publish.Period.init(steps: UInt8(data.retransmitIntervalSteps), resolution: stepResolution!)
            let publish = Publish.init(to: MeshAddress(Address(exactly: Int16(data.publishAddress))!), using: appKey, usingFriendshipMaterial: data.credentialFlag, ttl: UInt8(data.publishTtl), period: period, retransmit: retransmit)
            let node = meshNetworkManager.meshNetwork?.node(withAddress: Address(exactly: data.elementAddress)!)
            let element = node!.element(withAddress: Address(exactly: data.elementAddress)!)
            let model = element!.model(withModelId: UInt32(data.modelIdentifier))
            let message: ConfigModelPublicationSet = ConfigModelPublicationSet(publish, to: model!)!
            do {
                _ = try meshNetworkManager.send(message, to: node!)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendLightLightness(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            let message: LightLightnessSet = LightLightnessSet(lightness: UInt16(data.lightness))
            do {
                _ = try meshNetworkManager.send(message, to: MeshAddress(Address(bitPattern: data.address)), using: appKey)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendLightCtl(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            let message = LightCTLSet(lightness: UInt16(data.lightness), temperature: UInt16(data.temperature), deltaUV: data.lightDeltaUV)
            do {
                _ = try meshNetworkManager.send(message, to: MeshAddress(Address(bitPattern: data.address)), using: appKey)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .sendLightHsl(let data):
            guard let appKey = meshNetworkManager.meshNetwork?.applicationKeys[KeyIndex(data.keyIndex)] else{
                let error = MeshNetworkError.keyIndexOutOfRange
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                return
            }
            let message = LightHSLSet(lightness: UInt16(data.lightness), hue: UInt16(data.hue), saturation: UInt16(data.saturation))
            do {
                _ = try meshNetworkManager.send(message, to: MeshAddress(Address(bitPattern: data.address)), using: appKey)
                result(nil)
            } catch {
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .isAdvertisingWithNetworkIdentity(let data):
            result(isAdvertisingWithNetworkIdentity(data: data.serviceData.data))
        case .isAdvertisedWithNodeIdentity(let data):
            result(isAdvertisedWithNodeIdentity(data: data.serviceData.data))
        case .nodeIdentityMatches(let data):
            let hastAndRandom = nodeIdentityMatches(data: data.serviceData.data)
            result(meshNetworkManager.meshNetwork?.matches(hash: hastAndRandom!.hash, random: hastAndRandom!.random))
        case .networkIdMatches(let data):
            result(networkIdMatches(data: data.serviceData.data))
        }
        
    }
    
}


private extension DoozMeshManagerApi{
    
    func isAdvertisingWithNetworkIdentity(data: Data) -> Bool{
        guard data.count == 9, data[0] == 0x00 else {
            return false
        }
        return true
    }
    
    func isAdvertisedWithNodeIdentity(data: Data) -> Bool{
        guard data.count == 17, data[0] == 0x01 else {
            return false
        }
        return true
    }
    
    func nodeIdentityMatches(data: Data) -> (hash: Data, random: Data)?{
        guard data.count == 17, data[0] == 0x01 else {
            return nil
        }
        return (hash: data.subdata(in: 1..<9), random: data.subdata(in: 9..<17))
    }
    
    func networkIdMatches(data: Data) -> Bool{
        let nId = data.subdata(in: 1..<9);
        let nKeys = meshNetworkManager.meshNetwork?.networkKeys
        let generatedNetworkId = nKeys![0].networkId!
        guard nId.hex == generatedNetworkId.hex else {
            return false
        }
        return true
    }
    
    func _loadMeshNetwork() throws -> MeshNetwork {
        
        do{
            
            if try meshNetworkManager.load(){
                // Mesh Network loaded from database
            }else{
                // No mesh network in database, we have to create one
                let meshNetwork = _generateMeshNetwork()
                
                try _ = meshNetwork.add(networkKey: Data.random128BitKey(), name: "Network Key 1")
                
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 1")
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 2")
                try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 3")

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
    
    
    func _importMeshNetworkJson(_ json: String) throws -> MeshNetwork {
        
        
        do{
            // It’s safe to force-unwrap the result of string-to-data transformation only when you use a Unicode encoding.
            let data = json.data(using: .utf8)!
            let _network = try meshNetworkManager.import(from: data)
            
            if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork.uuid != _network.uuid) {
                doozMeshNetwork = DoozMeshNetwork(messenger: messenger, network: _network)
            } else {
                doozMeshNetwork?.meshNetwork = _network
            }
            
            return _network
            
        }catch{
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
    
    func _exportMeshNetwork() -> String{

        let data = meshNetworkManager.export()
        let str = String(decoding: data, as: UTF8.self)
        
        return str

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
    
    /// Delete the existing network in local database and recreate a new / empty Mesh Network
    func _resetMeshNetwork() throws{
//        guard let _meshNetwork = meshNetworkManager.meshNetwork else{
//            return
//        }
        
        do{
//            try _deleteMeshNetworkFromDb(_meshNetwork.uuid.uuidString)
//            let _ = _generateMeshNetwork()
            let meshNetwork = _generateMeshNetwork()
                        
            try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 1")
            try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 2")
            try _ = meshNetwork.add(applicationKey: Data.random128BitKey(), name: "Application Key 3")

            _ = meshNetworkManager.save()
            delegate?.onNetworkLoaded(meshNetwork)
        }catch{
            throw(error)
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
        
        if (doozMeshNetwork == nil || doozMeshNetwork?.meshNetwork.uuid != network.uuid) {
            doozMeshNetwork = DoozMeshNetwork(messenger: messenger, network: network)
        } else {
            doozMeshNetwork?.meshNetwork = network
        }
        
        let message: FlutterMessage =
            [
                EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkLoaded.rawValue,
                EventSinkKeys.id.rawValue : network.uuid.uuidString
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
            EventSinkKeys.id.rawValue : network.uuid.uuidString
        ]
        
        _sendFlutterMessage(message)
    }
    
    func onNetworkImported(_ network: MeshNetwork) {
        
        let message: FlutterMessage = [
            EventSinkKeys.eventName.rawValue : MeshNetworkApiEvent.onNetworkImported.rawValue,
            EventSinkKeys.id.rawValue : network.uuid.uuidString
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
    
    func provisioningStateDidChange(unprovisionedDevice: UnprovisionedDevice, state: ProvisioningState) {
        Swift.print("the provisioning state here ______________________________\(state)")
        Swift.print("the flutter state of provisioning here ___________________\(state.flutterState())")
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


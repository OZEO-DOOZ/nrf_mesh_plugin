//
//  DoozProvisioningManager.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 20/07/2020.
//

import UIKit
import nRFMeshProvision

protocol DoozProvisioningManagerDelegate{
    func provisioningStateDidChange(device: UnprovisionedDevice, state: ProvisionigState, eventSinkMessage: Dictionary<String, Any>)
    func didFinishProvisioning()
    
    func sendMessage(_ msg: Dictionary<String, Any>)
}

class DoozProvisioningManager: NSObject {
    
    //MARK: Public properties
    public var delegate: DoozProvisioningManagerDelegate?
    
    //MARK: Private properties
    private var meshNetworkManager: MeshNetworkManager?
    private var provisioningManager: ProvisioningManager?
    private var messenger: FlutterBinaryMessenger?
    
    private var unprovisionedDevices = [DoozUnprovisionedDevice]()
    
    private var unprovisionedDevice: UnprovisionedDevice?
    
    private var provisioningBearer: DoozPBGattBearer?
    private var provisionedBearer: DoozGattBearer?
    
    private var compositionDataGetNeeded = false
    private var node: Node?
    
    init(meshNetworkManager: MeshNetworkManager, messenger: FlutterBinaryMessenger, delegate: DoozProvisioningManagerDelegate) {
        super.init()
        self.meshNetworkManager = meshNetworkManager
        meshNetworkManager.delegate = self
        self.delegate = delegate
        self.messenger = messenger
    }
    
    func identifyNode(_ uuid: UUID){
        do{
            
            self.provisioningBearer = DoozPBGattBearer(targetWithIdentifier: uuid)
            if let _bearer = self.provisioningBearer{
                self.unprovisionedDevice = UnprovisionedDevice(uuid: uuid)
                self.provisioningBearer = DoozPBGattBearer(targetWithIdentifier: uuid)
                
                if let _unprovisionedDevice = self.unprovisionedDevice{
                    self.provisioningManager = try meshNetworkManager?.provision(unprovisionedDevice: _unprovisionedDevice, over: _bearer)
                    
                    self.provisioningManager?.logger = self
                    _bearer.delegate = self
                    _bearer.doozDelegate = self
                    _bearer.open()
                }
            }
            
        }catch{
            print(error)
        }
        
    }
    
    func provision(){
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
    }
    
    public func didDeliverData(data: [Int]){
        guard
            let _provisioningManager = self.provisioningManager,
            let _provisioningBearer = self.provisioningBearer,
            let type = PduType(rawValue: UInt8(data[0])) else{
                return
        }

        let encodedData = Data(bytes: data, count: MemoryLayout<Int>.size)

        _provisioningManager.bearer(_provisioningBearer, didDeliverData: encodedData, ofType: type)
    }
    
}

private extension DoozProvisioningManager{
    func provisionerDidProvisionNewDevice(_ node: Node){
        if let _meshNetworkManager = self.meshNetworkManager{
            let localProvisioner = _meshNetworkManager.meshNetwork?.localProvisioner
            guard localProvisioner?.hasConfigurationCapabilities ?? false else {
                // The Provisioner cannot sent or receive messages.
                
                return
            }
            
            self.node = node
            
            self.provisionedBearer = DoozGattBearer(targetWithIdentifier: unprovisionedDevice!.uuid)
            
            if let _gattBearer = provisionedBearer{
                _gattBearer.delegate = self
                //_gattBearer.logger = self
                _gattBearer.open()
                _gattBearer.dataDelegate = _meshNetworkManager
                
                _meshNetworkManager.transmitter = _gattBearer
                _meshNetworkManager.delegate = self
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
                _ = try _meshNetworkManager.send(message, to: _node)
                compositionDataGetNeeded = false
                
            }catch{
                print(error)
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
                _ = try _meshNetworkManager.send(message, to: _node)
                
            }catch{
                print(error)
            }
            
        }
    }
    
    func sendAppKey(){
        if let _meshNetworkManager = self.meshNetworkManager, let _node = self.node{
            do{
                
                if let _appKey = _meshNetworkManager.meshNetwork?.applicationKeys.first{
                    _ = try _meshNetworkManager.send(ConfigAppKeyAdd(applicationKey: _appKey), to: _node)
                    print("💪 SEND APP KEY")
                }
            }catch{
                print(error)
            }
            
        }
        
    }
}


extension DoozProvisioningManager: MeshNetworkDelegate{
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        print("📣 didReceiveMessage : \(message) from \(source) to \(destination)")
        
        switch message {
            
        case is ConfigCompositionDataStatus:
            self.getTtl()
            
        case is ConfigDefaultTtlStatus:
            self.sendAppKey()
        case is ConfigAppKeyStatus:
            delegate?.didFinishProvisioning()
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


extension DoozProvisioningManager: ProvisioningDelegate{
    
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
        
        let dict = [
            EventSinkKeys.eventName : state.eventName(),
            EventSinkKeys.state : state.flutterState(),
            "data":[],
            "meshNode":[
                "uuid":unprovisionedDevice.uuid.uuidString
            ]
            ] as [String : Any]
        
        delegate?.provisioningStateDidChange(device: unprovisionedDevice, state: state, eventSinkMessage: dict)
        
        
    }
    
    func authenticationActionRequired(_ action: AuthAction) { }
    
    func inputComplete() { }
}


extension DoozProvisioningManager: BearerDelegate{
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
        
        return
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

extension DoozProvisioningManager: GattBearerDelegate{
    func bearerDidConnect(_ bearer: Bearer) {
        print("✅ CONNECTED TO BEARER")
    }
}

extension DoozProvisioningManager: LoggerDelegate{
    func log(message: String, ofCategory category: LogCategory, withLevel level: LogLevel) {
        print("[\(String(describing: self.classForCoder))] \(message)")
    }
}

extension DoozProvisioningManager: DoozPBGattBearerDelegate{
    func send(data: Data, type: PduType) {
        
        //        Log.d(this.javaClass.name, "sendProvisioningPdu")
        //        eventSink?.success(mapOf(
        //                "eventName" to "sendProvisioningPdu",
        //                "pdu" to pdu,
        //                "meshNodeUuid" to meshNode?.deviceUuid?.toString()
        //        ))
        
        #warning("rename meshNodeUuid into meshNode.uuid to keep consistence of code ? same on android.")
        let dict = [
            EventSinkKeys.eventName : "sendProvisioningPdu",
            "pdu":data,
            "meshNodeUuid":provisioningBearer?.identifier.uuidString
            //            "meshNode":[
            //                "uuid":unprovisionedDevice.uuid.uuidString
            //            ]
            ] as [String : Any]
        
        delegate?.sendMessage(dict)
        
    }
}

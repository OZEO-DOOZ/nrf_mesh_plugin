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
        
    private var provisionedDevice: DoozProvisionedDevice?
    
    init(meshNetworkManager: MeshNetworkManager, messenger: FlutterBinaryMessenger, delegate: DoozProvisioningManagerDelegate) {
        super.init()
        self.meshNetworkManager = meshNetworkManager
        self.delegate = delegate
        self.messenger = messenger
    }
    
    func identifyNode(_ uuid: UUID){
        do{
            
            self.provisioningBearer = DoozPBGattBearer(targetWithIdentifier: uuid)
            if let _bearer = self.provisioningBearer{
                self.unprovisionedDevice = UnprovisionedDevice(uuid: uuid)
                
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
    
    func didDeliverData(_ data: Data, ofType type: PduType){
        guard
            let _provisioningManager = self.provisioningManager,
            let _provisioningBearer = self.provisioningBearer
            else{
                return
        }
        
        let packet = data.subdata(in: 1 ..< data.count)
        _provisioningManager.bearer(_provisioningBearer, didDeliverData: packet, ofType: type)
        
    }
    
    func cleanProvisioningData(){
        unprovisionedDevices.removeAll()
        unprovisionedDevice = nil
    }
    
    func createMeshPduForConfigCompositionDataGet(_ dest: Int16){
        if
            let _meshNetworkManager = self.meshNetworkManager,
            let _node = _meshNetworkManager.meshNetwork?.node(withAddress: Address(bitPattern: dest)){
            
            let message = ConfigCompositionDataGet()
            
            do{
                print("📩 Sending message : ConfigCompositionDataGet")
                _ = try _meshNetworkManager.send(message, to: _node)
            }catch{
                print(error)
            }
        }
    }
    
    func createMeshPduForConfigAppKeyAdd(dest: Int16, appKey: ApplicationKey){
        if
            let _meshNetworkManager = self.meshNetworkManager,
            let _node = _meshNetworkManager.meshNetwork?.node(withAddress: Address(bitPattern: dest)){
            let message = ConfigAppKeyAdd(applicationKey: appKey)
            do{
                print("📩 Sending message : ConfigAppKeyAdd")
                _ = try _meshNetworkManager.send(message, to: _node)
            }catch{
                print(error)
            }
            
        }
        
    }
}

extension DoozProvisioningManager: ProvisioningDelegate{
    
    func provisioningState(of unprovisionedDevice: UnprovisionedDevice, didChangeTo state: ProvisionigState) {
        
        if let _messenger = self.messenger{
            if !(unprovisionedDevices.contains(where: { $0.unprovisionedDevice?.uuid == unprovisionedDevice.uuid })) {
                unprovisionedDevices.append(DoozUnprovisionedDevice(messenger: _messenger, unprovisionedDevice: unprovisionedDevice, provisioningManager: provisioningManager))
            }
        }
        
        switch state {
        case .complete:
            if let _bearer = self.provisioningBearer{
                _bearer.close()
            }
            
            if
                let _messenger = self.messenger,
                let _meshNetwork = meshNetworkManager?.meshNetwork,
                let _node = _meshNetwork.node(for: unprovisionedDevice){
                self.provisionedDevice = DoozProvisionedDevice(messenger: _messenger, node: _node)
            }
            
        default:
            break
        }
        
        let dict = [
            EventSinkKeys.eventName.rawValue : state.eventName(),
            EventSinkKeys.state.rawValue : state.flutterState(),
            EventSinkKeys.data.rawValue:[],
            EventSinkKeys.meshNode.meshNode.rawValue:[
                EventSinkKeys.meshNode.uuid.rawValue:unprovisionedDevice.uuid.uuidString
            ]
            ] as [String : Any]
        
        delegate?.provisioningStateDidChange(device: unprovisionedDevice, state: state, eventSinkMessage: dict)
        
        
    }
    
    func authenticationActionRequired(_ action: AuthAction) { }
    
    func inputComplete() { }
}


extension DoozProvisioningManager: BearerDelegate{
    func bearerDidOpen(_ bearer: Bearer) {
        
        if bearer is DoozPBGattBearer{
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
        
    }
    
    func bearer(_ bearer: Bearer, didClose error: Error?) {
        guard let _provisioningManager = self.provisioningManager, case .complete = _provisioningManager.state else {
            print("Device disconnected")
            return
        }
        print("Provisioning complete")
        
        if let _meshNetworkManager = self.meshNetworkManager{
            if _meshNetworkManager.save(), let _unprovisionedDevice = self.unprovisionedDevice{
                if let _meshNetwork = _meshNetworkManager.meshNetwork {
                    _meshNetworkManager.localElements = []
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

extension DoozProvisioningManager: DoozPBGattBearerDelegate, DoozGattBearerDelegate, DoozTransmitterDelegate{
    func send(data: Data) {
        
        guard let _provisioningBearer = self.provisioningBearer else{
            return
        }
        
        let dict = [
            
            EventSinkKeys.eventName.rawValue: ProvisioningEvent.sendProvisioningPdu.rawValue,
            EventSinkKeys.pdu.rawValue: data,
            EventSinkKeys.meshNode.meshNode.rawValue:[
                EventSinkKeys.meshNode.uuid.rawValue: _provisioningBearer.identifier.uuidString
            ]
            ] as [String : Any]
        
        delegate?.sendMessage(dict)
        
    }
}

//
//  DoozMeshNetwork.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 01/06/2020.
//

import Foundation
import nRFMeshProvision

class DoozMeshNetwork: NSObject{
    
    //MARK: Public properties
    #warning("make meshNetwork private ?")
    var meshNetwork: MeshNetwork
    
    
    //MARK: Private properties
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger, network: MeshNetwork) {
        self.meshNetwork = network
        self.messenger = messenger
        
        super.init()
        
        _initChannel(messenger: messenger, networkId: network.id)
    }
    
    
}

private extension DoozMeshNetwork {
    
    func _initChannel(messenger: FlutterBinaryMessenger, networkId: String) {
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozMeshNetwork.getMethodChannelName(networkId: networkId),
            binaryMessenger: messenger
        )
        .setMethodCallHandler { (call, result) in
            self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        let _method = DoozMeshNetworkChannel(call: call)
        
        switch _method {
        case .error(let error):
            switch error {
            case FlutterCallError.notImplemented:
                result(FlutterMethodNotImplemented)
            default:
                #warning("manage other errors")
                print("❌ Plugin method - \(call.method) - isn't implemented")
            }
            
        case .getId:
            result(_getId())
            break
        case .getMeshNetworkName:
            result(_getMeshNetworkName())
            break
        case .selectProvisioner(let data):
            
            do{
                let provisioner = meshNetwork.provisioners[data.provisionerIndex]
                try meshNetwork.setLocalProvisioner(provisioner)
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            
            break
        case .highestAllocatableAddress:
            
            var maxAddress = 0
            
            if let _allocatedUnicastRanges = meshNetwork.localProvisioner?.allocatedUnicastRange{
                for addressRange in _allocatedUnicastRanges {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = Int(addressRange.highAddress)
                    }
                }
            }
            
            result(maxAddress)
            
            break
            
        case .nodes:
            
            
            let provisionedDevices = meshNetwork.nodes.map({ node  in
                return DoozProvisionedDevice(messenger: messenger, node: node)
            })
            
            let nodes = provisionedDevices.map({ device in
                return [
                    EventSinkKeys.network.uuid.rawValue: device.node.uuid.uuidString
                ]
            })
            
            result(nodes)
            
            break
            
        case .selectedProvisionerUuid:
            result(meshNetwork.localProvisioner?.uuid.uuidString)
            break
            
        case .addGroupWithName(let data):
            #warning("❌ TO TEST")
            if
                let provisioner = meshNetwork.localProvisioner,
                let address = meshNetwork.nextAvailableGroupAddress(for: provisioner){
                
                do{
                    let group = try Group(name: data.name, address: address)
                    try meshNetwork.add(group: group)
                    
                    result(
                        [
                            "group" : [
                                "name" : group.name,
                                "address" : group.address,
                                "addressLabel" : group.address.virtualLabel?.uuidString,
                                //"meshUuid" : group.
                                "parentAddress" : group.parent?.address,
                                "parentAddressLabel" : group.parent?.address.virtualLabel?.uuidString
                            ],
                            "successfullyAdded" : true
                            
                        ]
                    )
                }catch{
                    #warning("TODO : manage errors")
                    print(error)
                }
                
            }
            
        case .groups:
            #warning("❌ TO TEST")
            
            let groups = meshNetwork.groups.map({ group in
                return [
                    "name" : group.name,
                    "address" : group.address,
                    "addressLabel" : group.address.virtualLabel?.uuidString,
                    //"meshUuid" : group.
                    "parentAddress" : group.parent?.address,
                    "parentAddressLabel" : group.parent?.address.virtualLabel?.uuidString
                ]
            })
            
            result(groups)
            
        case .removeGroup(let data):
            #warning("❌ TO TEST")
            if let group = meshNetwork.group(withAddress: MeshAddress(Address(bitPattern: data.groupAddress))) {
                
                do{
                    try meshNetwork.remove(group: group)
                    result(true)
                }
                catch{
                    print(error)
                    result(false)
                }
                
            }else{
                result(false)
            }
                        
        case .getElementsForGroup(let data):
            #warning("❌ TO TEST")
            if let group = meshNetwork.group(withAddress: MeshAddress(Address(bitPattern: data.address))){
                let models = meshNetwork.models(subscribedTo: group)
                let elements = models.compactMap { model in
                    return model.parentElement
                }
                
                let mappedElements = elements.map { element in
                    return [
                        "name" : element.name,
                        "address" : element.unicastAddress,
                        "locationDescriptor" : element.location,
                        "models" : models.filter({$0.parentElement == element}).map({ m in
                            return [
                                "subscribedAddresses" : m.subscriptions.map({ s in
                                    return s.address
                                }),
                                "boundAppKey" : m.boundApplicationKeys.map{ key in
                                    return key.index
                                }
                            ]
                        })
                    ]
                }
                
                result(mappedElements)
            }else{
                result(false)
            }
        }
    }
}

private extension DoozMeshNetwork{
    
    func _getMeshNetworkName() -> String?{
        return meshNetwork.meshName
    }
    
    func _getId() -> String?{
        return meshNetwork.id
    }
    
}

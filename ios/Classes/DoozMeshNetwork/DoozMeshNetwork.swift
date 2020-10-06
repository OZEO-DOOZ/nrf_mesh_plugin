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
    var meshNetwork: MeshNetwork?
    
    //MARK: Private properties
    private var eventSink: FlutterEventSink?
    private var messenger: FlutterBinaryMessenger?
    
    init(messenger: FlutterBinaryMessenger, network: MeshNetwork) {
        super.init()
        self.meshNetwork = network
        self.messenger = messenger
        _initChannels(messenger: messenger, network: network)
    }
    
    
}

private extension DoozMeshNetwork {
    
    func _initChannels(messenger: FlutterBinaryMessenger, network: MeshNetwork){
        
        FlutterEventChannel(
            name: FlutterChannels.DoozMeshNetwork.getEventChannelName(networkId: network.id),
            binaryMessenger: messenger
        )
        .setStreamHandler(self)
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozMeshNetwork.getMethodChannelName(networkId: network.id),
            binaryMessenger: messenger
        )
        .setMethodCallHandler { (call, result) in
            self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        
        guard let _method = DoozMeshNetworkChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
        case .getId:
            result(_getId())
            break
        case .getMeshNetworkName:
            result(_getMeshNetworkName())
            break
        case .highestAllocatableAddress:
            
            var maxAddress = 0
            
            if let _allocatedUnicastRanges = meshNetwork?.localProvisioner?.allocatedUnicastRange{
                for addressRange in _allocatedUnicastRanges {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = Int(addressRange.highAddress)
                    }
                }
            }
            
            result(maxAddress)
            
            break
            
        case .nodes:
            
            if
                let _messenger = self.messenger,
                let _meshNetwork = self.meshNetwork {
                let provisionedDevices = _meshNetwork.nodes.map({ node  in
                    return DoozProvisionedDevice(messenger: _messenger, node: node)
                })
                
                let nodes = provisionedDevices.map({ device in
                    return [EventSinkKeys.network.uuid.rawValue: device.node.uuid.uuidString]
                })
                
                result(nodes)
                
            }
            
            break
        case .selectedProvisionerUuid:
            result(meshNetwork?.localProvisioner?.uuid.uuidString)
            break
            
        case .addGroupWithName:
            
            if
                let provisioner = meshNetwork?.localProvisioner,
                let address = meshNetwork?.nextAvailableGroupAddress(for: provisioner),
                let _args = call.arguments as? [String:Any],
                let _name = _args["name"] as? String {
                
                do{
                    let group = try Group(name: _name, address: address)
                    try meshNetwork?.add(group: group)
                    
                    result(
                        [
                            "group" : [
                                //"id"
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
            
            
        }
    }
}

private extension DoozMeshNetwork{
    
    func _getMeshNetworkName() -> String?{
        return meshNetwork?.meshName
    }
    
    func _getId() -> String?{
        return meshNetwork?.id
    }
    
}

extension DoozMeshNetwork: FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
}

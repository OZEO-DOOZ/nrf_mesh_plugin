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

    init(messenger: FlutterBinaryMessenger, network: MeshNetwork) {
        super.init()
        self.meshNetwork = network
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
        case .nextAvailableUnicastAddress:
            
            if
                let _args = call.arguments as? [String:Any],
                let _elementSize = _args["elementSize"] as? UInt8,
                let _provisioner = meshNetwork?.localProvisioner{
                
                #warning("the returned address is failing when we provision (address already in use)")
                let nextAvailableUnicastAddress = meshNetwork?.nextAvailableUnicastAddress(for: _elementSize, elementsUsing: _provisioner)
                result(nextAvailableUnicastAddress)
            }
            
            break
            
        case .assignUnicastAddress:
            do{
                if
                    let _args = call.arguments as? [String:Any],
                    let _unicastAddress = _args["unicastAddress"] as? UInt16,
                    let _provisioner = meshNetwork?.localProvisioner{
                    
                    //try meshNetwork?.assign(unicastAddress: _unicastAddress, for: _provisioner)
                    
                    result(nil)
                }

            }catch{
                print("Failed to assign unicast address : \(error)")
            }
            
        }

    }
    
}

private extension DoozMeshNetwork{
    // Events native implemenations
    
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

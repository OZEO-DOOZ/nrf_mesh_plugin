//
//  DoozUnprovisionedMeshNode.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 06/07/2020.
//

import Foundation
import nRFMeshProvision

class DoozUnprovisionedMeshNode: NSObject{
    
    //MARK: Public properties
    var unprovisionedMeshNode: UnprovisionedDevice?
    
    //MARK: Private properties
    private var eventSink: FlutterEventSink?

    init(messenger: FlutterBinaryMessenger, unprovisionedMeshNode: UnprovisionedDevice) {
        super.init()
        self.unprovisionedMeshNode = unprovisionedMeshNode
        _initChannels(messenger: messenger, unprovisionedMeshNode: unprovisionedMeshNode)
    }
    
    
}

private extension DoozUnprovisionedMeshNode {
    
    func _initChannels(messenger: FlutterBinaryMessenger, unprovisionedMeshNode: UnprovisionedDevice){

        FlutterMethodChannel(
            name: FlutterChannels.DoozUnprovisionedMeshNode.getMethodChannelName(deviceUUID: unprovisionedMeshNode.uuid.uuidString),
            binaryMessenger: messenger
        )
            .setMethodCallHandler { (call, result) in
                self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        
        guard let _method = DoozUnprovisionedMeshNodeChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
        
        case .getNumberOfElements:
            
            break
            
        case .setUnicastAddress:
            #warning("to implement or remove if useless in ios")
            break
        }

    }
    
}

//private extension DoozUnprovisionedMeshNode{
//    // Events native implemenations
//    
//    func _getMeshNetworkName() -> String?{
//        return meshNetwork?.meshName
//    }
//    
//    func _getId() -> String?{
//        return meshNetwork?.id
//    }
//
//}

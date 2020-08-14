//
//  DoozProvisionedDevice.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 07/08/2020.
//

import Foundation
import nRFMeshProvision

class DoozProvisionedDevice: NSObject{
    
    //MARK: Public properties
    
    //MARK: Private properties
    private var eventSink: FlutterEventSink?
    private var node: Node?
    
    init(messenger: FlutterBinaryMessenger, node: Node){
        super.init()
        self.node = node
        _initChannels(messenger: messenger, uuid: node.uuid)
    }
    
    
}

private extension DoozProvisionedDevice {
    
    func _initChannels(messenger: FlutterBinaryMessenger, uuid: UUID){
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozProvisionedMeshNode.getMethodChannelName(deviceUUID: uuid.uuidString),
            binaryMessenger: messenger
        )
            .setMethodCallHandler { (call, result) in
                self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        
        guard let _method = DoozProvisionedMeshNodeChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
            
        case .unicastAddress:
            guard let _node = self.node else{
                result(nil)
                return
            }
            
            result(_node.unicastAddress)
            
        case .nodeName:
            if
                let _node = self.node,
                let _args = call.arguments as? [String:Any],
                let _name = _args["name"] as? String {
                
                _node.name = _name
                
            }
            result(nil)
        }
        
    }
}


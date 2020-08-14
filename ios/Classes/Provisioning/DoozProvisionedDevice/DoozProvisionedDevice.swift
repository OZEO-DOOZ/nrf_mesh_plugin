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
    private var provisioningManager: ProvisioningManager?
    private var uuid: UUID?
    
    init(messenger: FlutterBinaryMessenger, provisioningManager: ProvisioningManager, uuid: UUID) {
        super.init()
        self.uuid = uuid
        self.provisioningManager = provisioningManager
        _initChannels(messenger: messenger, uuid: uuid)
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
            guard let _provisioningManager = self.provisioningManager else{
                result(nil)
                return
            }
            
            result(_provisioningManager.unicastAddress)
            
        case .nodeName:
            if
                let _args = call.arguments as? [String:Any],
                let _name = _args["name"] as? Int{
            }
            result(nil)
        }
        
    }
    
}

//
//  DoozUnprovisionedMeshNode.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 06/07/2020.
//

import Foundation
import nRFMeshProvision

class DoozUnprovisionedDevice: NSObject{
    
    //MARK: Public properties
    var unprovisionedDevice: UnprovisionedDevice?
    
    //MARK: Private properties
    private var provisioningManager: ProvisioningManager?
    
    init(messenger: FlutterBinaryMessenger, unprovisionedDevice: UnprovisionedDevice, provisioningManager: ProvisioningManager?) {
        super.init()
        self.unprovisionedDevice = unprovisionedDevice
        self.provisioningManager = provisioningManager
        _initChannels(messenger: messenger, unprovisionedDevice: unprovisionedDevice)
    }
    
    
}

private extension DoozUnprovisionedDevice {
    
    func _initChannels(messenger: FlutterBinaryMessenger, unprovisionedDevice: UnprovisionedDevice){
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozUnprovisionedMeshNode.getMethodChannelName(deviceUUID: unprovisionedDevice.uuid.uuidString),
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
            
            var nbElements = 0
            if let _nbElements = provisioningManager?.provisioningCapabilities?.numberOfElements{
                nbElements = Int(_nbElements)
            }
            result(nbElements)
            break
            
        }
    }
}

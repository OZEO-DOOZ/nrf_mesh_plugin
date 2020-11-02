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
        _initChannel(messenger: messenger, unprovisionedDevice: unprovisionedDevice)
    }
    
}

private extension DoozUnprovisionedDevice {
    
    func _initChannel(messenger: FlutterBinaryMessenger, unprovisionedDevice: UnprovisionedDevice){
        
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
        
        let _method = DoozUnprovisionedMeshNodeChannel(call: call)
        
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

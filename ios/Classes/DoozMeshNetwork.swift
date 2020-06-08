//
//  DoozMeshNetwork.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 01/06/2020.
//

import Foundation
import nRFMeshProvision

enum DoozMeshNetworkChannel: String{
    case getId
    case getMeshNetworkName
}

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
        }

    }
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

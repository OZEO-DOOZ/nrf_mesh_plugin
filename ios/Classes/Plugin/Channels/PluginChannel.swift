//
//  PluginChannels.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

import Foundation

//enum PluginMethodChannel: String{
//    case getPlatformVersion
//    case createMeshManagerApi
//}

enum PluginMethodChannel {
    
    case getPlatformVersion
    case createMeshManagerApi
    
    case error(_ error: Error)
    
    init(call: FlutterMethodCall) {

        switch call.method {
        case "getPlatformVersion":
            self = .getPlatformVersion
        case "createMeshManagerApi":
            self = .createMeshManagerApi
            
        default:
            self = .error(FlutterCallError.notImplemented)
        }
    }
    
}

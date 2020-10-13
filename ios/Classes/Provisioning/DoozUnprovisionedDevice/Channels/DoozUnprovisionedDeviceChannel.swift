//
//  DoozUnprovisionedMeshNodeChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 06/07/2020.
//

enum DoozUnprovisionedMeshNodeChannel {
    case getNumberOfElements
    
    case error(_ error: Error)
    
    init(call: FlutterMethodCall) {
        //let arguments = call.arguments as? FlutterCallArguments

        //do{
        switch call.method {
        case "getNumberOfElements":
            self = .getNumberOfElements
        
        default:
            self = .error(FlutterCallError.notImplemented)
        }
//        }catch{
//            self = .error(error)
//        }
        
    }
}

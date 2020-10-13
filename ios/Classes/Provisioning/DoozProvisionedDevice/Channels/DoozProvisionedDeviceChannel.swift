//
//  DoozProvisionedDeviceChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 07/08/2020.
//

enum DoozProvisionedMeshNodeChannel {
    case unicastAddress
    case nodeName(_ data: NodeNameArguments)
    case name
    case elements
    case elementAt

    case error(_ error: Error)

    init(call: FlutterMethodCall) {
        let arguments = call.arguments as? FlutterCallArguments

        do{
            switch call.method {
            case "unicastAddress":
                self = .unicastAddress
            case "nodeName":
                self = .nodeName(try NodeNameArguments(arguments))
            case "name":
                self = .name
            case "elements":
                self = .elements
            case "elementAt":
                self = .elementAt
            
            default:
                self = .error(FlutterCallError.notImplemented)
            }
        }catch{
            self = .error(error)
        }
        
    }
}

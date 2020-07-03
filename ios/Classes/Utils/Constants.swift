//
//  Constants.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 01/06/2020.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

struct DoozStorage{
    static let fileName = "DoozMeshNetwork.json"
}

struct FlutterChannels{
    private static let prodNamespace = "fr.dooz.nordic_nrf_mesh"
    
    private static let namespace = prodNamespace
    
    private static let eventsUrl = "/events"
    private static let methodsUrl = "/methods"
    
    struct Plugin{
        static func getMethodChannelName() -> String{
            return "\(namespace)\(methodsUrl)"
        }
    }
    
    struct DoozMeshNetwork{
        static let url = "/mesh_network"
        
        static func getEventChannelName(networkId: String) -> String{
            return "\(namespace)\(url)\(networkId)\(eventsUrl)"
        }
        
        static func getMethodChannelName(networkId: String) -> String{
            return "\(namespace)\(url)\(networkId)\(methodsUrl)"
        }
        
    }
    
    struct MeshManagerApi{
        static let url = "/mesh_manager_api"
        
        static func getEventChannelName() -> String{
            return "\(namespace)\(url)\(eventsUrl)"
        }
        
        static func getMethodChannelName() -> String{
            return "\(namespace)\(url)\(methodsUrl)"
        }
    }
        
}

enum MeshNetworkApiEvent: String{
    case onNetworkLoaded
    case onNetworkImported
    case onNetworkUpdated
    
    case onNetworkLoadFailed
    case onNetworkImportFailed
    
    case onProvisioningStateChanged
}

struct EventSinkKeys{
    static let eventName = "eventName"
    static let id = "id"
    static let error = "error"
    
    static let state = "state"
}

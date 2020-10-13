//
//  ProvisioningState+Dooz.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

import nRFMeshProvision

extension ProvisionigState{
    
    func eventName() -> String{
        switch self {
        
        case .complete:
            return ProvisioningEvent.onProvisioningCompleted.rawValue
        case .fail(_):
            return ProvisioningEvent.onProvisioningFailed.rawValue
        default:
            return ProvisioningEvent.onProvisioningStateChanged.rawValue
            
        }
    }
    
    func flutterState() -> String {
        switch self {
        
        case .capabilitiesReceived(_):
            return "PROVISIONING_CAPABILITIES"
        case .ready:
            return "PROVISIONER_READY"
        case .requestingCapabilities:
            return "REQUESTING_CAPABILITIES"
        case .provisioning:
            return "PROVISIONING"
        default:
            return ""
            
        }
    }
    
}

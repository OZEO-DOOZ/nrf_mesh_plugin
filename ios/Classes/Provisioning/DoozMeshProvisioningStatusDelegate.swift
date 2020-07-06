//
//  DoozMeshProvisioningStatusCallbacks.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 06/07/2020.
//

import Foundation
import nRFMeshProvision

protocol DoozMeshProvisioningStatusDelegate{
    
    var mtuSize: Int { get set }

//    func onProvisioningStateChanged(unprovisionedDevice: UnprovisionedDevice, state: ProvisioningState)
//    func onProvisioningFailed(unprovisionedDevice: UnprovisionedDevice, state: ProvisioningState)
//    func onProvisioningCompleted(unprovisionedDevice: UnprovisionedDevice, state: ProvisioningState)
    
}




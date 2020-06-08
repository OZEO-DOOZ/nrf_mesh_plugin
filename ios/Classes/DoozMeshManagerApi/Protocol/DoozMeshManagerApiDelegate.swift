//
//  DoozMeshManagerApiDelegate.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

import Foundation
import nRFMeshProvision

protocol DoozMeshManagerApiDelegate{
    
    func onNetworkLoaded(_ network: MeshNetwork?)
    func onNetworkLoadFailed(_ error: Error)
    
    func onNetworkUpdated(_ network: MeshNetwork?)
    
    func onNetworkImported(_ network: MeshNetwork?)
    func onNetworkImportFailed(_ error: Error)
    
    #warning("TODO: Implement pdu and mtu methods")
//    func sendProvisioningPdu(meshNode: UnprovisionedDevice, pdu: Int[])
//    func getMtu() -> Int

}


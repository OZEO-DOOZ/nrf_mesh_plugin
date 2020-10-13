//
//  DoozMeshManagerApiDelegate.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

import Foundation
import nRFMeshProvision

protocol DoozMeshManagerApiDelegate{
    
    var mtuSize: Int { get set }
    
    func onNetworkLoaded(_ network: MeshNetwork)
    func onNetworkLoadFailed(_ error: Error)
    
    func onNetworkUpdated(_ network: MeshNetwork)
    
    func onNetworkImported(_ network: MeshNetwork)
    func onNetworkImportFailed(_ error: Error)
    
}


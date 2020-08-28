//
//  DoozMeshManagerApiChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

enum DoozMeshManagerApiChannel: String{
    case loadMeshNetwork
    case importMeshNetworkJson
    case deleteMeshNetworkFromDb
    case exportMeshNetwork
    
    case identifyNode
    case handleNotifications
    case setMtuSize
    case cleanProvisioningData
    
    case provisioning
    
    case createMeshPduForConfigAppKeyAdd
    case createMeshPduForConfigCompositionDataGet
    
    case sendConfigModelAppBind
    
    case sendGenericLevelSet
    case sendGenericOnOffSet
    
    case getSequenceNumberForAddress
}

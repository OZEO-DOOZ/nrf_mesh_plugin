//
//  DoozMeshManagerApiError.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

enum DoozMeshManagerApiError: Error{
    case errorLoadingMeshNetwork
    case errorSavingMeshNetwork
    
    public var errorDescription: String? {
        switch self {
        case .errorLoadingMeshNetwork:
            return "Mesh network load failed"
        case .errorSavingMeshNetwork:
            return "Mesh network save failed"
        }
    }
}

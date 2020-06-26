//
//  DoozMeshManagerApiError.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

enum DoozMeshManagerApiError: Error{
    case meshManagerApiNotInitialized
    case doozStorageNotFound
    
    
    public var errorDescription: String? {
        switch self {
        case .meshManagerApiNotInitialized:
            return "MeshManagerApi has not been initialized"
        case .doozStorageNotFound:
            return "DoozStorage file not found"
        }
    }
}

//
//  LocalStorage+Dooz.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

import nRFMeshProvision

enum DoozLocalStorageError: Error{
    case storageFileDoesNotExists
    case unknown
}

extension LocalStorage{
    
    // Use this to delete the local database
    func delete() throws {
        
        if let _url = self.getStorageFile(){
            do{
                try FileManager.default.removeItem(at: _url)
            }catch{
                throw error
            }
        }else{
            throw DoozLocalStorageError.storageFileDoesNotExists
        }
    }
}


//
//  AddProvisionerArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 29/07/2021.
//

struct AddProvisionerArguments: BaseFlutterArguments {
    let name: String
    let unicastAddressRange: Int
    let groupAddressRange: Int
    let sceneAddressRange: Int
    let globalTtl: Int
}

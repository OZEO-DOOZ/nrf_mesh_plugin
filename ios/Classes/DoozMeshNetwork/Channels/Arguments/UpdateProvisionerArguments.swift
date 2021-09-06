//
//  UpdateProvisionerArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 30/07/2021.
//

struct UpdateProvisionerArguments: BaseFlutterArguments {
    let provisionerUuid: String
    let provisionerName: String
    let provisionerAddress: Int
    let globalTtl: Int
    let lastSelected: Bool
}

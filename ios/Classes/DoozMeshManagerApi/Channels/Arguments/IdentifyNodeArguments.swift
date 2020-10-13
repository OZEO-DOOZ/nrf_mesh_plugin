//
//  IdentifyNodeArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct IdentifyNodeArguments: BaseFlutterArguments {
    let serviceUuid: String
    private(set) lazy var uuid: UUID = {
        UUID(uuidString: serviceUuid)!
    }()
}

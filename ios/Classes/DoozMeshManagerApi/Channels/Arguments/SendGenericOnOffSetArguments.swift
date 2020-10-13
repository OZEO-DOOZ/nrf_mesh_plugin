//
//  SendGenericOnOffSetArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendGenericOnOffSetArguments: BaseFlutterArguments {
    let address: Int16
    let value: Bool
    let keyIndex: Int16
}

//
//  SendLightHslArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 02/08/2021.
//

struct SendLightHslArguments: BaseFlutterArguments {
    let address: Int16
    let lightness: Int
    let keyIndex: Int
    let hue: Int
    let saturation: Int16
}

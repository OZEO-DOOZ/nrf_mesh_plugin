//
//  SendLightCtlArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 02/08/2021.
//

struct SendLightCtlArguments: BaseFlutterArguments {
    let address: Int16
    let lightness: Int
    let keyIndex: Int
    let temperature: Int
    let lightDeltaUV: Int16
}

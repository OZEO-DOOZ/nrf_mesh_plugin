//
//  SendConfigModelAppBindArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendConfigModelAppBindArguments: BaseFlutterArguments {
    let nodeId: Int16
    let elementId: Int16
    let modelId: UInt32
    let appKeyIndex: Int16
}

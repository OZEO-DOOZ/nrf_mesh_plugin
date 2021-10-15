//
//  SendConfigModelAppBindArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendConfigModelAppBindArguments: BaseFlutterArguments {
    let nodeId: Int
    let elementId: Int
    let modelId: Int
    let appKeyIndex: Int
}

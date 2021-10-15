//
//  SendGenericLevelSetArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendGenericLevelSetArguments: BaseFlutterArguments {
    let address: Int
    let level: Int
    let keyIndex: Int
    let transitionStep: Int
    let transitionResolution: Int
    let delay: Int
}

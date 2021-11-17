//
//  SendV2MagicLevelArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 20/10/2021.
//

import Foundation

struct SendV2MagicLevelArguments: BaseFlutterArguments {
    let io: Int
    let index: Int
    let value: Int
    let correlation: Int
    let keyIndex: Int
    let address: Int
}

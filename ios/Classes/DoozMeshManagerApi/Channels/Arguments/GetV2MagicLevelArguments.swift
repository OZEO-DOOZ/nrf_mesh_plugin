//
//  GetV2MagicLevelArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 20/10/2021.
//

import Foundation

struct GetV2MagicLevelArguments: BaseFlutterArguments {
    let io: Int
    let index: Int
    let correlation: Int16
    let keyIndex: Int
    let address: Int
}

//
//  DoozEpochSetArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 11/02/2022.
//

import Foundation

struct DoozEpochSetArguments: BaseFlutterArguments {
    let address: Int
    let keyIndex: Int
    let tzData: Int16
    let command: UInt8
    let io: UInt8
    let unused: UInt8
    let epoch: UInt32
    let correlation: UInt32
    let extra: UInt8?
}

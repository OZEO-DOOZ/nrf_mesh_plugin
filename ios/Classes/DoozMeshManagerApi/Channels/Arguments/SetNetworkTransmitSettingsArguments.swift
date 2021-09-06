//
//  SetNetworkTransmitSettingsArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 02/08/2021.
//

struct SetNetworkTransmitSettingsArguments: BaseFlutterArguments {
    let address: Int16
    let transmitCount: Int
    let transmitIntervalSteps: Int
}

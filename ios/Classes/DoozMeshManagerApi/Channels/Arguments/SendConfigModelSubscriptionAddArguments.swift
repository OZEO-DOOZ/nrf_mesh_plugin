//
//  SendConfigModelSubscriptionAddArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendConfigModelSubscriptionAddArguments: BaseFlutterArguments {
    let address: Int16
    let elementAddress: Int16
    let subscriptionAddress: Int16
    let modelIdentifier: UInt32
}

//
//  SendConfigModelSubscriptionDeleteArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct SendConfigModelSubscriptionDeleteArguments: BaseFlutterArguments {
    let elementAddress: Int
    let subscriptionAddress: Int
    let modelIdentifier: Int
}

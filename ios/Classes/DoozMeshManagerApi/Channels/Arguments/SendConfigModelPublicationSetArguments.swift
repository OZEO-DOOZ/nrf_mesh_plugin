//
//  SendConfigModelPublicationSetArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 02/08/2021.
//

struct SendConfigModelPublicationSetArguments: BaseFlutterArguments  {
    let elementAddress: Int16
    let publishAddress: Int
    let appKeyIndex: Int
    let credentialFlag: Bool
    let publishTtl: Int
    let publicationSteps: Int
    let publicationResolution: Int
    let retransmitCount: Int
    let retransmitIntervalSteps: Int
    let modelIdentifier: Int
}

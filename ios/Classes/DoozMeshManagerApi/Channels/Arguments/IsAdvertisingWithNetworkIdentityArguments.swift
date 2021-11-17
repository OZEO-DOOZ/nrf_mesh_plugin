//
//  IsAdvertisingWithNetworkIdentityArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 14/09/2021.
//

import Foundation

struct IsAdvertisingWithNetworkIdentityArguments {
    let serviceData: FlutterStandardTypedData
    init(_ arguments: FlutterCallArguments?) throws {
        guard let _arguments = arguments else{
            throw FlutterCallError.missingArguments
        }
        
        guard
            let serviceData = _arguments["serviceData"] as? FlutterStandardTypedData
        else{
            throw FlutterCallError.errorDecoding
        }
            
        self.serviceData = serviceData
        
    }
}

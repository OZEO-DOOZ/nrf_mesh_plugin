//
//  HandleWriteCallbacksArguments.swift
//  nordic_nrf_mesh
//
//  Created by OZEO DOOZ on 20/10/2021.
//

import Foundation

struct HandleWriteCallbacksArguments {
    let mtu: Int
    let pdu: FlutterStandardTypedData
    
    init(_ arguments: FlutterCallArguments?) throws {
        guard let _arguments = arguments else{
            throw FlutterCallError.missingArguments
        }
        
        guard
            let pdu = _arguments["pdu"] as? FlutterStandardTypedData,
            let mtu = _arguments["mtu"] as? Int
        else{
            throw FlutterCallError.errorDecoding
        }
            
        self.mtu = mtu
        self.pdu = pdu
        
    }

}

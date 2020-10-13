//
//  HandleNotificationsArguments.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

struct HandleNotificationsArguments {
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

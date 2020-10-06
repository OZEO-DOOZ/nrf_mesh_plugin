//
//  DoozTransmitter.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 07/08/2020.
//

import Foundation
import nRFMeshProvision

public protocol DoozTransmitterDelegate{
    func send(data: Data)
}

class DoozTransmitter: Transmitter{
    
    public var doozDelegate: DoozGattBearerDelegate?
    
    func send(_ data: Data, ofType type: PduType) throws {
        // Add the pdu type to the data before sending it via flutter_blue
        var packet = Data([type.rawValue])
        packet += data
        doozDelegate?.send(data: packet)
    }
}

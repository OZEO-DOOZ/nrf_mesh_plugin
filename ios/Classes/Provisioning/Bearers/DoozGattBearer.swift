//
//  DoozGattBearer.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 24/07/2020.
//

import Foundation
import nRFMeshProvision

public protocol DoozGattBearerDelegate{
    func send(data: Data)
}

open class DoozGattBearer: Bearer {
    
    public var delegate: BearerDelegate?
    public var dataDelegate: BearerDataDelegate?
    public var isOpen: Bool
    
    public var identifier: UUID
    public var name: String?
    public var doozDelegate: DoozGattBearerDelegate?
    
    
    init(targetWithIdentifier uuid: UUID) {
        identifier = uuid
        isOpen = false
    }
    
    public func send(_ data: Data, ofType type: PduType) throws {
        // Add the pdu type to the data before sending it via flutter_blue
        var packet = Data([type.rawValue])
        packet += data
        doozDelegate?.send(data: packet)
    }
    
    public func open() {
        isOpen = true
        delegate?.bearerDidOpen(self)
    }
    
    public func close() {
        
    }
    
    public var supportedPduTypes: PduTypes{
        return [.networkPdu, .meshBeacon, .proxyConfiguration]
    }
    
}

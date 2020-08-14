//
//  DoozPBGattBearer.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 24/07/2020.
//

import Foundation
import nRFMeshProvision

public protocol DoozPBGattBearerDelegate{
    func send(data: Data)
}

open class DoozPBGattBearer: ProvisioningBearer {
    
    public var delegate: BearerDelegate?
    public var dataDelegate: BearerDataDelegate?
    
    public var isOpen: Bool
    
    public var doozDelegate: DoozPBGattBearerDelegate?
    public var identifier: UUID
    public var name: String?
    
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
        delegate?.bearer(self, didClose: nil)
    }
    
    public var supportedPduTypes: PduTypes {
        return [.provisioningPdu]
    }
    
}

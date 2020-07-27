//
//  DoozGattBearer.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 24/07/2020.
//

import Foundation
import nRFMeshProvision

protocol DoozGattBearerDelegate{
    
}

open class DoozGattBearer: Bearer {
    
    public var delegate: BearerDelegate?
    public var dataDelegate: BearerDataDelegate?
    public var isOpen: Bool
    
    public var identifier: UUID
    public var name: String?
    
    
    init(targetWithIdentifier uuid: UUID) {
        identifier = uuid
        isOpen = false
    }
        
    public func send(_ data: Data, ofType type: PduType) throws {
        print("[DoozGattBearer] CALLING SEND - not implemented yet")
    }
    
    public func open() {
        
    }
    
    public func close() {
        
    }
    
    public var supportedPduTypes: PduTypes{
        return [.networkPdu, .meshBeacon, .proxyConfiguration]
    }
    
//    public override var supportedPduTypes: PduTypes{
//        return [.networkPdu, .meshBeacon, .proxyConfiguration]
//    }
//
//    open override func send(_ data: Data, ofType type: PduType) throws {
//        #warning("call delegate to send message via flutter")
//    }
    
}

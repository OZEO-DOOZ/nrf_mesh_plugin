//
//  DoozMeshManagerApi+FlutterMessage.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

extension DoozMeshManagerApi {
    typealias FlutterMessage = [String : Any]
    
    func _sendFlutterMessage(_ message: FlutterMessage) {
        guard let _eventSink = self.eventSink else {
            return
        }
        
        _eventSink(message)
    }
}


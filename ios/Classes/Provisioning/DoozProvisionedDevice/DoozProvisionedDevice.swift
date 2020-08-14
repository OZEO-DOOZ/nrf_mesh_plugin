//
//  DoozProvisionedDevice.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 07/08/2020.
//

import Foundation
import nRFMeshProvision

class DoozProvisionedDevice: NSObject{
    
    //MARK: Public properties
    public var node: Node
    
    //MARK: Private properties
    private var eventSink: FlutterEventSink?
    
    
    init(messenger: FlutterBinaryMessenger, node: Node){
        self.node = node
        super.init()
        _initChannels(messenger: messenger, uuid: node.uuid)
    }
    
}

private extension DoozProvisionedDevice {
    
    func _initChannels(messenger: FlutterBinaryMessenger, uuid: UUID){
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozProvisionedMeshNode.getMethodChannelName(deviceUUID: uuid.uuidString),
            binaryMessenger: messenger
        )
            .setMethodCallHandler { (call, result) in
                self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        
        guard let _method = DoozProvisionedMeshNodeChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
            
        case .unicastAddress:
            result(node.unicastAddress)
            
        case .nodeName:
            if
                let _args = call.arguments as? [String:Any],
                let _name = _args["name"] as? String {
                
                node.name = _name
                
            }
            result(nil)
            
        case .elements:
            #warning("WIP")
            #warning("no 'key' on ios ?")
            #warning("on model : modelId is private but we have access to modelIdentifier")
            
//            "elements" -> {
//                result.success(meshNode.elements.map { element ->
//                    mapOf(
//                            "key" to element.key,
//                            "address" to element.value.elementAddress,
//                            "location" to element.value.locationDescriptor,
//                            "models" to element.value.meshModels.map {
//                                mapOf(
//                                        "key" to it.key,
//                                        "id" to it.value.modelId,
//                                        "subscribedAddresses" to it.value.subscribedAddresses
//                                )
//                            }
//                    )
//                })
//            }
            
            node.elements.map { element in
                return [
                    //"key": element
                    "address" : element.unicastAddress,
                    "location" : element.location.rawValue,
                    "models" : element.models.map({ model in
                        return [
                            "id" : model.modelIdentifier,
                            "subscribedAddresses" : model.subscriptions.map{ sub in
                                return sub.address
                            }
                        ]
                    })
                ]
            }
            
            
            
        case .elementAt:
            #warning("WIP")
        }
        
    }
}


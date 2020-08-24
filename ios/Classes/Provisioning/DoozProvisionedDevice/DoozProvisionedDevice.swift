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
        
        case .name:
            #warning("Wrong name here; returns 'iPhone de xxx'")
            result(node.name)
            
        case .elements:
            #warning("address : unicastAddress ou Address(index) ?")
            #warning("we dont have access to boundAppKey on iOS")
            //in model : "boundAppKey" to it.value.boundAppKeyIndexes
                                  
            var elements = node.elements.map { element in
                return [
                    EventSinkKeys.meshNode.elements.key.rawValue: element.index,
                    EventSinkKeys.meshNode.elements.address.rawValue : element.unicastAddress,
                    EventSinkKeys.meshNode.elements.locationDescriptor.rawValue : element.location.rawValue,
                    EventSinkKeys.meshNode.elements.models.rawValue : element.models.enumerated().map({ (index,model) in
                        return [
                            EventSinkKeys.meshNode.elements.model.key.rawValue : index,
                            EventSinkKeys.meshNode.elements.model.modelId.rawValue : model.modelIdentifier,
                            EventSinkKeys.meshNode.elements.model.subscribedAddresses.rawValue : model.subscriptions.map{ sub in
                                return sub.address
                            },
                            EventSinkKeys.meshNode.elements.model.boundAppKey.rawValue : model.boundApplicationKeys.map{ key in
                                return key.index
                            }
                            
                        ]
                      
                    })
                ]
            }

            result(elements)
            
        case .elementAt:
            #warning("WIP")
            //node.element(withAddress: <#T##Address#>)
        case .getSequenceNumber:
            #warning("Wrong sequence number")
            result(99)
            //node.meshNetwork.getSequenceNumber(of: node.elements[0])
            //result()

        }
        
    }
}


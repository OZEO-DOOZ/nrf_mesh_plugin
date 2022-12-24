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
        
        let _method = DoozProvisionedMeshNodeChannel(call: call)
        
        switch _method {
        
        case .error(let error):
            switch error {
            case FlutterCallError.notImplemented:
                result(FlutterMethodNotImplemented)
            case FlutterCallError.missingArguments:
                result(FlutterError(code: "missingArguments", message: "The provided arguments does not match required", details: nil))
            case FlutterCallError.errorDecoding:
                result(FlutterError(code: "errorDecoding", message: "An error occured attempting to decode arguments", details: nil))
            default:
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
        
            break
        case .unicastAddress:
            result(node.primaryUnicastAddress)
            break
        case .nodeName(let data):
            node.name = data.name
            result(nil)
            break
        case .name:
            result(node.name)
            break
        case .elements:
            let elements = node.elements.map { element in
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
            //node.element(withAddress: <#T##Address#>)
            break
                        
        }
        
    }
}


//
//  DoozMeshManagerApi+MeshNetworkDelegate.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 13/10/2020.
//

import Foundation
import nRFMeshProvision

extension DoozMeshManagerApi: MeshNetworkDelegate{
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        print("📣 didReceiveMessage : \(message) from \(source) to \(destination)")
        
        // Handle the message based on its type.
        switch message {
        
        case let status as ConfigModelAppStatus:
            
            if status.isSuccess {
                let message: FlutterMessage = [
                    
                    EventSinkKeys.eventName.rawValue: MessageEvent.onConfigModelAppStatus.rawValue,
                    EventSinkKeys.message.elementAddress.rawValue: status.elementAddress,
                    EventSinkKeys.message.modelId.rawValue: status.modelId,
                    EventSinkKeys.message.appKeyIndex.rawValue: status.applicationKeyIndex,
                    
                ]
                
                _sendFlutterMessage(message)
                
            } else {
                break
            }
            
        case is ConfigCompositionDataStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigCompositionDataStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.meshMessage.rawValue : [
                    EventSinkKeys.message.source.rawValue : source,
                    EventSinkKeys.message.destination.rawValue : destination
                ]
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigAppKeyStatus:
            if status.isSuccess {
                let message: FlutterMessage = [
                    
                    EventSinkKeys.eventName.rawValue : MessageEvent.onConfigAppKeyStatus.rawValue,
                    EventSinkKeys.source.rawValue : source,
                    EventSinkKeys.message.meshMessage.rawValue : [
                        EventSinkKeys.message.source.rawValue : source,
                        EventSinkKeys.message.destination.rawValue : destination
                    ]
                    
                ]
                
                _sendFlutterMessage(message)
            }else {
                break
            }
            
        case let status as GenericLevelStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onGenericLevelStatus.rawValue,
                EventSinkKeys.level.rawValue : status.level,
                EventSinkKeys.targetLevel.rawValue : status.targetLevel ?? 0,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination
                
            ]
            
            _sendFlutterMessage(message)
            
            
        //        case let list as ConfigModelAppList:
        //            break
        //
        //        case let list as ConfigModelSubscriptionList:
        //            break
        //
        //        case let status as ConfigModelPublicationStatus:
        //            break
        //
        //        case let status as ConfigModelSubscriptionStatus:
        //            break
        
        default:
            break
        }
        
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didSendMessage message: MeshMessage, from localElement: Element, to destination: Address) {
        print("📣 didSendMessage : \(message) from \(localElement) to \(destination)")
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, failedToSendMessage message: MeshMessage, from localElement: Element, to destination: Address, error: Error) {
        print("📣 failedToSendMessage : \(message) from \(localElement) to \(destination) : \(error)")
    }
    
}

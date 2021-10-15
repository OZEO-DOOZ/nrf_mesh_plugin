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
                EventSinkKeys.message.level.rawValue : status.level,
                EventSinkKeys.message.targetLevel.rawValue : status.targetLevel ?? 0,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.transitionResolution.rawValue : status.remainingTime?.stepResolution.rawValue ?? 0,
                EventSinkKeys.message.transitionSteps.rawValue : status.remainingTime?.steps ?? 0,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as GenericOnOffStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onGenericOnOffStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.presentState.rawValue : status.isOn,
                EventSinkKeys.message.targetState.rawValue : status.targetState ?? false,
                EventSinkKeys.message.transitionResolution.rawValue : status.remainingTime?.stepResolution.rawValue ?? 0,
                EventSinkKeys.message.transitionSteps.rawValue : status.remainingTime?.steps ?? 0,
            
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigModelSubscriptionStatus:
            #warning("check the data type of status.address here in this status")
            Swift.print("the subscriptionAddress from the feedback of model subscription is \(status.address)")
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigModelSubscriptionStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.elementAddress.rawValue: status.elementAddress,
                EventSinkKeys.message.subscriptionAddress.rawValue : status.address,
                EventSinkKeys.message.modelIdentifier.rawValue : status.modelIdentifier,
                EventSinkKeys.message.isSuccessful.rawValue : status.isSuccess,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigModelPublicationStatus:
            
            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigModelPublicationStatus.rawValue,
                EventSinkKeys.message.elementAddress.rawValue: status.elementAddress,
                EventSinkKeys.message.publishAddress.rawValue : status.publish.publicationAddress,
                EventSinkKeys.message.appKeyIndex.rawValue : status.publish.index,
                EventSinkKeys.message.credentialFlag.rawValue : status.publish.isUsingFriendshipSecurityMaterial,
                EventSinkKeys.message.publishTtl.rawValue : status.publish.ttl,
                EventSinkKeys.message.publicationSteps.rawValue : status.publish.period.numberOfSteps,
                EventSinkKeys.message.publicationResolution.rawValue : status.publish.period.resolution,
                EventSinkKeys.message.retransmitCount.rawValue : status.publish.retransmit.count,
                EventSinkKeys.message.retransmitIntervalSteps.rawValue : status.publish.retransmit.steps,
                EventSinkKeys.message.modelIdentifier.rawValue : status.modelIdentifier,
                EventSinkKeys.message.isSuccessful.rawValue : status.isSuccess,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as LightLightnessStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onLightLightnessStatus.rawValue,
                EventSinkKeys.message.presentLightness.rawValue : status.lightness,
                EventSinkKeys.message.targetLightness.rawValue : status.targetLightness ?? 0,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.transitionResolution.rawValue : status.remainingTime?.stepResolution.rawValue ?? 0,
                EventSinkKeys.message.transitionSteps.rawValue : status.remainingTime?.steps ?? 0,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as LightCTLStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onLightCtlStatus.rawValue,
                EventSinkKeys.message.presentLightness.rawValue : status.lightness,
                EventSinkKeys.message.targetLightness.rawValue : status.targetLightness ?? 0,
                EventSinkKeys.message.presentTemperature.rawValue : status.temperature,
                EventSinkKeys.message.targetTemperature.rawValue : status.targetTemperature ?? 0,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.transitionResolution.rawValue : status.remainingTime?.stepResolution.rawValue ?? 0,
                EventSinkKeys.message.transitionSteps.rawValue : status.remainingTime?.steps ?? 0,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as LightHSLStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onLightHslStatus.rawValue,
                EventSinkKeys.message.presentLightness.rawValue : status.lightness,
                EventSinkKeys.message.presentHue.rawValue : status.hue,
                EventSinkKeys.message.presentSaturation.rawValue : status.saturation,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.transitionResolution.rawValue : status.remainingTime?.stepResolution.rawValue ?? 0,
                EventSinkKeys.message.transitionSteps.rawValue : status.remainingTime?.steps ?? 0,
                
            ]
            
            _sendFlutterMessage(message)
            
        case _ as ConfigNodeResetStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigNodeResetStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.success.rawValue : true,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigNetworkTransmitStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigNetworkTransmitStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.transmitCount.rawValue : status.count,
                EventSinkKeys.message.transmitIntervalSteps.rawValue : status.steps,
                
            ]
            
            _sendFlutterMessage(message)
            
        case let status as ConfigDefaultTtlStatus:

            let message: FlutterMessage = [
                
                EventSinkKeys.eventName.rawValue : MessageEvent.onConfigDefaultTtlStatus.rawValue,
                EventSinkKeys.source.rawValue : source,
                EventSinkKeys.message.destination.rawValue : destination,
                EventSinkKeys.message.ttl.rawValue : status.ttl,
                
            ]
            
            _sendFlutterMessage(message)
        //        case let list as ConfigModelAppList:
        //            break
        //
        //        case let status as ConfigModelSubscriptionList:
        //            break
        
        default:
            break
        }
        delegate?.onNetworkUpdated(manager.meshNetwork!)
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didSendMessage message: MeshMessage, from localElement: Element, to destination: Address) {
        print("📣 didSendMessage : \(message) from \(localElement) to \(destination)")
    }
    
    func meshNetworkManager(_ manager: MeshNetworkManager, failedToSendMessage message: MeshMessage, from localElement: Element, to destination: Address, error: Error) {
        print("📣 failedToSendMessage : \(message) from \(localElement) to \(destination) : \(error)")
    }
    
}

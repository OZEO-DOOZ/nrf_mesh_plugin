//
//  DoozMeshManagerApiChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

enum DoozMeshManagerApiChannel {
    
    case loadMeshNetwork
    case importMeshNetworkJson(_ data: ImportMeshNetworkJsonArguments)
    case deleteMeshNetworkFromDb(_ data: DeleteMeshNetworkFromDbArguments)
    case exportMeshNetwork
    case resetMeshNetwork
    case identifyNode(_ data: IdentifyNodeArguments)
    case handleNotifications(_ data: HandleNotificationsArguments)
    case handleWriteCallbacks(_ data: HandleWriteCallbacksArguments)
    case setMtuSize(_ data: MtuSizeArguments)
    case cleanProvisioningData
    case provisioning
    case cachedProvisionedMeshNodeUuid
    case sendConfigCompositionDataGet(_ data: SendConfigCompositionDataGetArguments)
    case sendConfigAppKeyAdd(_ data: SendConfigAppKeyAddArguments)
    case sendConfigModelAppBind(_ data: SendConfigModelAppBindArguments)
    case sendGenericLevelSet(_ data: SendGenericLevelSetArguments)
    case sendGenericOnOffSet(_ data: SendGenericOnOffSetArguments)
    case sendConfigModelSubscriptionAdd(_ data: SendConfigModelSubscriptionAddArguments)
    case sendConfigModelSubscriptionDelete(_ data: SendConfigModelSubscriptionDeleteArguments)
    case getSequenceNumberForAddress(_ data: GetSequenceNumberForAddressArguments)
    case setSequenceNumberForAddress(_ data: SetSequenceNumberForAddressArguments)
    case sendGenericLevelGet(_ data: SendGenericLevelGetArguments)
    case setNetworkTransmitSettings(_ data: SetNetworkTransmitSettingsArguments)
    case getNetworkTransmitSettings(_ data: GetNetworkTransmitSettingsArguments)
    case getDefaultTtl(_ data: GetDefaultTtlArguments)
    case setDefaultTtl(_ data: SetDefaultTtlArguments)
    case sendConfigModelSubscriptionDeleteAll(_ data: SendConfigModelSubscriptionDeleteAllArguments)
    case sendConfigModelPublicationSet(_ data: SendConfigModelPublicationSetArguments)
    case sendLightLightness(_ data: SendLightLightnessArguments)
    case sendLightCtl(_ data: SendLightCtlArguments)
    case sendLightHsl(_ data: SendLightHslArguments)
    case isAdvertisingWithNetworkIdentity(_ data: IsAdvertisingWithNetworkIdentityArguments)
    case isAdvertisedWithNodeIdentity(_ data: IsAdvertisingWithNodeIdentityArguments)
    case nodeIdentityMatches(_ data: NodeIdentityMatchesArguments)
    case networkIdMatches(_ data: NetworkIdMatchesArguments)
    case sendV2MagicLevel(_ data: SendV2MagicLevelArguments)
    case getV2MagicLevel(_ data: GetV2MagicLevelArguments)

    case error(_ error: Error)
    
    init(call: FlutterMethodCall) {
        let arguments = call.arguments as? FlutterCallArguments

        do{
            switch call.method {
            case "loadMeshNetwork":
                self = .loadMeshNetwork
            case "importMeshNetworkJson":
                self = .importMeshNetworkJson(try ImportMeshNetworkJsonArguments(arguments))
            case "deleteMeshNetworkFromDb":
                self = .deleteMeshNetworkFromDb(try DeleteMeshNetworkFromDbArguments(arguments))
            case "exportMeshNetwork":
                self = .exportMeshNetwork
            case "resetMeshNetwork":
                self = .resetMeshNetwork
            case "identifyNode":
                self = .identifyNode(try IdentifyNodeArguments(arguments))
            case "handleNotifications":
                self = .handleNotifications(try HandleNotificationsArguments(arguments))
            case "setMtuSize":
                self = .setMtuSize(try MtuSizeArguments(arguments))
            case "cleanProvisioningData":
                self = .cleanProvisioningData
            case "provisioning":
                self = .provisioning
            case "sendConfigCompositionDataGet":
                self = .sendConfigCompositionDataGet(try SendConfigCompositionDataGetArguments(arguments))
            case "sendConfigAppKeyAdd":
                self = .sendConfigAppKeyAdd(try SendConfigAppKeyAddArguments(arguments))
            case "sendConfigModelAppBind":
                self = .sendConfigModelAppBind(try SendConfigModelAppBindArguments(arguments))
            case "sendGenericLevelSet":
                self = .sendGenericLevelSet(try SendGenericLevelSetArguments(arguments))
            case "sendGenericOnOffSet":
                self = .sendGenericOnOffSet(try SendGenericOnOffSetArguments(arguments))
            case "sendConfigModelSubscriptionAdd":
                self = .sendConfigModelSubscriptionAdd(try SendConfigModelSubscriptionAddArguments(arguments))
            case "sendConfigModelSubscriptionDelete":
                self = .sendConfigModelSubscriptionDelete(try SendConfigModelSubscriptionDeleteArguments(arguments))
            case "getSequenceNumberForAddress":
                self = .getSequenceNumberForAddress(try GetSequenceNumberForAddressArguments(arguments))
            case "setSequenceNumberForAddress":
                self = .setSequenceNumberForAddress(try SetSequenceNumberForAddressArguments(arguments))
            case "sendGenericLevelGet":
                self = .sendGenericLevelGet(try SendGenericLevelGetArguments(arguments))
            case "setNetworkTransmitSettings":
                self = .setNetworkTransmitSettings(try SetNetworkTransmitSettingsArguments(arguments))
            case "getNetworkTransmitSettings":
                self = .getNetworkTransmitSettings(try GetNetworkTransmitSettingsArguments(arguments))
            case "getDefaultTtl":
                self = .getDefaultTtl(try GetDefaultTtlArguments(arguments))
            case "setDefaultTtl":
                self = .setDefaultTtl(try SetDefaultTtlArguments(arguments))
            case "sendConfigModelSubscriptionDeleteAll":
                self = .sendConfigModelSubscriptionDeleteAll(try SendConfigModelSubscriptionDeleteAllArguments(arguments))
            case "sendConfigModelPublicationSet":
                self = .sendConfigModelPublicationSet(try SendConfigModelPublicationSetArguments(arguments))
            case "sendLightLightness":
                self = .sendLightLightness(try SendLightLightnessArguments(arguments))
            case "sendLightCtl":
                self = .sendLightCtl(try SendLightCtlArguments(arguments))
            case "sendLightHsl":
                self = .sendLightHsl(try SendLightHslArguments(arguments))
            case "isAdvertisingWithNetworkIdentity":
                self = .isAdvertisingWithNetworkIdentity(try IsAdvertisingWithNetworkIdentityArguments(arguments))
            case "isAdvertisedWithNodeIdentity":
                self = .isAdvertisedWithNodeIdentity(try IsAdvertisingWithNodeIdentityArguments(arguments))
            case "nodeIdentityMatches":
                self = .nodeIdentityMatches(try NodeIdentityMatchesArguments(arguments))
            case "networkIdMatches":
                self = .networkIdMatches(try NetworkIdMatchesArguments(arguments))
            case "sendV2MagicLevel":
                self = .sendV2MagicLevel(try SendV2MagicLevelArguments(arguments))
            case "getV2MagicLevel":
                self = .getV2MagicLevel(try GetV2MagicLevelArguments(arguments))
            
            //getDeviceUuid
            case "handleWriteCallbacks":
                self = .handleWriteCallbacks(try HandleWriteCallbacksArguments(arguments))
            
            
            case "cachedProvisionedMeshNodeUuid":
                self = .cachedProvisionedMeshNodeUuid
            //deprovision
            default:
                self = .error(FlutterCallError.notImplemented)
            }
        }catch{
            self = .error(error)
        }
        
    }
    
}

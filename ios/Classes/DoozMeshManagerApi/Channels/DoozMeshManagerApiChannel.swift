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
    case setMtuSize(_ data: MtuSizeArguments)
    case cleanProvisioningData
    case provisioning
    case sendConfigCompositionDataGet(_ data: SendConfigCompositionDataGetArguments)
    case sendConfigAppKeyAdd(_ data: SendConfigAppKeyAddArguments)
    case sendConfigModelAppBind(_ data: SendConfigModelAppBindArguments)
    case sendGenericLevelSet(_ data: SendGenericLevelSetArguments)
    case sendGenericOnOffSet(_ data: SendGenericOnOffSetArguments)
    case sendConfigModelSubscriptionAdd(_ data: SendConfigModelSubscriptionAddArguments)
    case sendConfigModelSubscriptionDelete(_ data: SendConfigModelSubscriptionDeleteArguments)
    case getSequenceNumberForAddress(_ data: GetSequenceNumberForAddressArguments)
    
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
            
            default:
                self = .error(FlutterCallError.notImplemented)
            }
        }catch{
            self = .error(error)
        }
        
    }
    
}

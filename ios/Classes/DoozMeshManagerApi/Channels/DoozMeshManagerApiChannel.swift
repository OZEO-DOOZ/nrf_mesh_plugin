//
//  DoozMeshManagerApiChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

typealias FlutterCallArguments = [String : Any]

enum DoozMeshManagerApiChannel {
    
    case loadMeshNetwork
    case importMeshNetworkJson(_ data: ImportMeshNetworkJsonArguments)
    case deleteMeshNetworkFromDb(_ data: DeleteMeshNetworkFromDbArguments)
    case exportMeshNetwork
    case identifyNode(_ data: IdentifyNodeArguments)
    case handleNotifications(_ data: HandleNotificationsArguments)
    case setMtuSize(_ data: MtuSizeArguments)
    case cleanProvisioningData
    case provisioning
    case createMeshPduForConfigCompositionDataGet(_ data: CreateMeshPduForConfigCompositionDataGetArguments)
    case createMeshPduForConfigAppKeyAdd(_ data: CreateMeshPduForConfigAppKeyAddArguments)
    
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
            case "createMeshPduForConfigCompositionDataGet":
                self = .createMeshPduForConfigCompositionDataGet(try CreateMeshPduForConfigCompositionDataGetArguments(arguments))
            case "createMeshPduForConfigAppKeyAdd":
                self = .createMeshPduForConfigAppKeyAdd(try CreateMeshPduForConfigAppKeyAddArguments(arguments))
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

enum FlutterCallError: Error{
    case missingArguments
    case notImplemented
    case errorDecoding
}

// MARK: Base protocol for arguments
protocol BaseFlutterArguments: Decodable{
    init(_ arguments: FlutterCallArguments?) throws
}

extension BaseFlutterArguments{
    
    init(_ arguments: FlutterCallArguments?) throws {
        guard let _arguments = arguments else{
            throw FlutterCallError.missingArguments
        }
        do{
            self = try JSONDecoder().decode(Self.self, from: JSONSerialization.data(withJSONObject: _arguments))
        }catch{
            throw FlutterCallError.errorDecoding
        }
    }
    
}

// MARK: ImportMeshNetworkJsonArguments
struct ImportMeshNetworkJsonArguments: BaseFlutterArguments {
    let json: String
}

// MARK: DeleteMeshNetworkFromDbArguments
struct DeleteMeshNetworkFromDbArguments: BaseFlutterArguments {
    let id: String
}

// MARK: IdentifyNodeArguments
struct IdentifyNodeArguments: BaseFlutterArguments {
    let serviceUuid: String
    private(set) lazy var uuid: UUID = {
        UUID(uuidString: serviceUuid)!
    }()
}

// MARK: MtuSizeArguments
struct MtuSizeArguments: BaseFlutterArguments {
    let mtuSize: Int
}

// MARK: HandleNotificationsArguments
struct HandleNotificationsArguments {
    let mtu: Int
    let pdu: FlutterStandardTypedData
    
    init(_ arguments: FlutterCallArguments?) throws {
        guard let _arguments = arguments else{
            throw FlutterCallError.missingArguments
        }
        
        guard
            let pdu = _arguments["pdu"] as? FlutterStandardTypedData,
            let mtu = _arguments["mtu"] as? Int
        else{
            throw FlutterCallError.errorDecoding
        }
            
        self.mtu = mtu
        self.pdu = pdu
        
    }

}

// MARK: CreateMeshPduForConfigCompositionDataGetArguments
struct CreateMeshPduForConfigCompositionDataGetArguments: BaseFlutterArguments {
    let dest: Int16
}

// MARK: CreateMeshPduForConfigAppKeyAddArguments
struct CreateMeshPduForConfigAppKeyAddArguments: BaseFlutterArguments {
    let dest: Int16
}

// MARK: SendConfigModelAppBindArguments
struct SendConfigModelAppBindArguments: BaseFlutterArguments {
    let nodeId: Int16
    let elementId: Int16
    let modelId: UInt32
    let appKeyIndex: Int16
}

// MARK: SendGenericLevelSetArguments
struct SendGenericLevelSetArguments: BaseFlutterArguments {
    let address: Int16
    let level: Int16
    let keyIndex: Int16
}

// MARK: SendGenericOnOffSetArguments
struct SendGenericOnOffSetArguments: BaseFlutterArguments {
    let address: Int16
    let value: Bool
    let keyIndex: Int16
}

// MARK: SendConfigModelSubscriptionAddArguments
struct SendConfigModelSubscriptionAddArguments: BaseFlutterArguments {
    let address: Int16
    let elementAddress: Int16
    let subscriptionAddress: Int16
    let modelIdentifier: UInt32
}

// MARK: SendConfigModelSubscriptionDeleteArguments
struct SendConfigModelSubscriptionDeleteArguments: BaseFlutterArguments {
    let address: Int16
    let elementAddress: Int16
    let subscriptionAddress: Int16
    let modelIdentifier: UInt32
}

// MARK: GetSequenceNumberForAddressArguments
struct GetSequenceNumberForAddressArguments: BaseFlutterArguments {
    let address: Int16
}

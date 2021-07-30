//
//  DoozMeshNetworkChannel.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 08/06/2020.
//

enum DoozMeshNetworkChannel {
    
    case getId
    case getMeshNetworkName
    case highestAllocatableAddress
    case nodes
    case selectedProvisionerUuid
    case addGroupWithName(_ data: AddGroupWithNameArguments)
    case groups
    case removeGroup(_ data: RemoveGroupArguments)
    case getElementsForGroup(_ data: GetElementsForGroupArguments)
    case selectProvisioner(_ data: SelectProvisionerArguments)
    case getProvisionersAsJson
    case getNodeUsingUUID(_ data: GetNodeArguments)
    case nextAvailableUnicastAddress
    case addProvisioner(_ data : AddProvisionerArguments)

    case error(_ error: Error)
    
    init(call: FlutterMethodCall) {
        let arguments = call.arguments as? FlutterCallArguments

        do{
            switch call.method {
            case "getId":
                self = .getId
            case "getMeshNetworkName":
                self = .getMeshNetworkName
            case "highestAllocatableAddress":
                self = .highestAllocatableAddress
            case "nodes":
                self = .nodes
            case "selectedProvisionerUuid":
                self = .selectedProvisionerUuid
            case "addGroupWithName":
                self = .addGroupWithName(try AddGroupWithNameArguments(arguments))
            case "groups":
                self = .groups
            case "removeGroup":
                self = .removeGroup(try RemoveGroupArguments(arguments))
            case "getElementsForGroup":
                self = .getElementsForGroup(try GetElementsForGroupArguments(arguments))
            case "selectProvisioner":
                self = .selectProvisioner(try SelectProvisionerArguments(arguments))
            case "getProvisionersAsJson":
                self = .getProvisionersAsJson
            case "getNodeUsingUUID":
                self = .getNodeUsingUUID(try GetNodeArguments(arguments))
            case "nextAvailableUnicastAddress":
                self = .nextAvailableUnicastAddress
            case "addProvisioner":
                self = .addProvisioner(try AddProvisionerArguments(arguments))
            default:
                self = .error(FlutterCallError.notImplemented)
            }
        }catch{
            self = .error(error)
        }
        
    }
    
}

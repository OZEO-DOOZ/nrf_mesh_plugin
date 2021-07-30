//
//  DoozMeshNetwork.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 01/06/2020.
//

import Foundation
import nRFMeshProvision

class DoozMeshNetwork: NSObject{
    
    //MARK: Public properties
    var meshNetwork: MeshNetwork
    
    //MARK: Private properties
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger, network: MeshNetwork) {
        self.meshNetwork = network
        self.messenger = messenger
        
        super.init()
        
        _initChannel(messenger: messenger, networkId: network.uuid.uuidString)
    }
    
    
}

private extension DoozMeshNetwork {
    
    func _initChannel(messenger: FlutterBinaryMessenger, networkId: String) {
        
        FlutterMethodChannel(
            name: FlutterChannels.DoozMeshNetwork.getMethodChannelName(networkId: networkId),
            binaryMessenger: messenger
        )
        .setMethodCallHandler { (call, result) in
            self._handleMethodCall(call, result: result)
        }
        
    }
    
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [\(self.classForCoder)] Received flutter call : \(call.method)")
        let _method = DoozMeshNetworkChannel(call: call)
        
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
        case .getId:
            result(_getId())
            break
        case .getMeshNetworkName:
            result(_getMeshNetworkName())
            break
        case .selectProvisioner(let data):
            
            do{
                let provisioner = meshNetwork.provisioners[data.provisionerIndex]
                try meshNetwork.setLocalProvisioner(provisioner)
                result(nil)
            }catch{
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            
            break
        case .highestAllocatableAddress:
            
            var maxAddress = 0
            
            if let _allocatedUnicastRanges = meshNetwork.localProvisioner?.allocatedUnicastRange{
                for addressRange in _allocatedUnicastRanges {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = Int(addressRange.highAddress)
                    }
                }
            }
            
            result(maxAddress)
            
            break
            
        case .nodes:
            
            let provisionedDevices = meshNetwork.nodes.map({ node  in
                return DoozProvisionedDevice(messenger: messenger, node: node)
            })
            
            let nodes = provisionedDevices.map({ device in
                return [
                    EventSinkKeys.network.uuid.rawValue: device.node.uuid.uuidString
                ]
            })
            
            result(nodes)
            
            break
            
        case .selectedProvisionerUuid:
            result(meshNetwork.localProvisioner?.uuid.uuidString)
            break
            
        case .addGroupWithName(let data):
            if
                let provisioner = meshNetwork.localProvisioner,
                let address = meshNetwork.nextAvailableGroupAddress(for: provisioner){
                
                do{
                    let group = try Group(name: data.name, address: address)
                    try meshNetwork.add(group: group)
                    
                    result(
                        [
                            "group" : [
                                "name" : group.name,
                                "address" : group.address,
                                "addressLabel" : group.address.virtualLabel?.uuidString ?? "",
                                "parentAddress" : group.parent?.address ?? "",
                                "parentAddressLabel" : group.parent?.address.virtualLabel?.uuidString ?? ""
                            ],
                            "successfullyAdded" : true
                            
                        ]
                    )
                }catch{
                    let nsError = error as NSError
                    result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                }
                
            }
            
        case .groups:
            let groups = meshNetwork.groups.map({ group in
                return [
                    "name" : group.name,
                    "address" : group.address,
                    "addressLabel" : group.address.virtualLabel?.uuidString ?? "",
                    "parentAddress" : group.parent?.address ?? "",
                    "parentAddressLabel" : group.parent?.address.virtualLabel?.uuidString ?? ""
                ]
            })
            
            result(groups)
            
        case .removeGroup(let data):
            if let group = meshNetwork.group(withAddress: MeshAddress(Address(bitPattern: data.groupAddress))) {
                
                do{
                    try meshNetwork.remove(group: group)
                    result(true)
                }
                catch{
                    let nsError = error as NSError
                    result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
                }
                
            }else{
                result(false)
            }
                        
        case .getElementsForGroup(let data):
            if let group = meshNetwork.group(withAddress: MeshAddress(Address(bitPattern: data.address))){
                let models = meshNetwork.models(subscribedTo: group)
                let elements = models.compactMap { model in
                    return model.parentElement
                }
                
                let mappedElements = elements.map { element in
                    return [
                        "name" : element.name ?? "",
                        "address" : element.unicastAddress,
                        "locationDescriptor" : element.location,
                        "models" : models.filter({$0.parentElement == element}).map({ m in
                            return [
                                "subscribedAddresses" : m.subscriptions.map({ s in
                                    return s.address
                                }),
                                "boundAppKey" : m.boundApplicationKeys.map{ key in
                                    return key.index
                                }
                            ]
                        })
                    ]
                }
                
                result(mappedElements)
            }else{
                result(false)
            }

        case .getProvisionersAsJson:

            let provisionerList : [Provisioner] = meshNetwork.provisioners
            var customProvisionerList = [CustomProvisioner]()
            provisionerList.forEach { provisioner in
                let provisionerNode = meshNetwork.node(for: provisioner)!

                //unicastAddress
                let lowUnicastAddress = provisioner.allocatedUnicastRange.first!.lowAddress
                let highUnicastAddress = provisioner.allocatedUnicastRange.first!.highAddress

                //groupAddress
                let lowGroupAddress = provisioner.allocatedGroupRange.first!.lowAddress
                let highGroupAddress = provisioner.allocatedGroupRange.first!.highAddress

                //sceneAddress
                let firstSceneAddress = provisioner.allocatedSceneRange.first!.firstScene
                let lastSceneAddress = provisioner.allocatedSceneRange.first!.lastScene

                customProvisionerList.append(CustomProvisioner.init(name: provisioner.name, uuid: provisioner.uuid.uuidString, globalTtl: Int(provisionerNode.defaultTTL ?? 0), unicastAddress: Int(provisionerNode.unicastAddress.description, radix: 16) ?? 0, isLocal: provisioner.isLocal, allocatedUnicastRange: [AllocatedUnicastAndGroupRange.init(lowAddress: lowUnicastAddress, highAddress: highUnicastAddress)], allocatedGroupRange: [AllocatedUnicastAndGroupRange.init(lowAddress: lowGroupAddress, highAddress: highGroupAddress)], allocatedSceneRange: [AllocatedSceneRange.init(firstScene: firstSceneAddress, lastScene: lastSceneAddress)]))
            }

            do{
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(customProvisionerList)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)

                result(json)
            } catch let error {
                print(error.localizedDescription)
            }
            
        case .getNodeUsingUUID(let data):

            let provisionedMeshNode = meshNetwork.node(withUuid: UUID.init(uuidString: data.uuid)!)

            _ = DoozProvisionedDevice.init(messenger: messenger, node: provisionedMeshNode!)
//                            val pNode = DoozProvisionedMeshNode(binaryMessenger, provisionedMeshNode)
            result(provisionedMeshNode?.uuid.uuidString)
            
        case .nextAvailableUnicastAddress:
            
//            let provisionerUnicastAddress = meshNetwork.localProvisioner?.unicastAddress
            let nextAvailableUnicastAddress = meshNetwork.nextAvailableUnicastAddress(for: meshNetwork.localProvisioner!)
            #warning("TODO: impl. nextAvailableUnicastAddressWithMin or complete the below workaround")
//            if(Int(provisionerUnicastAddress!) >= Int(nextAvailableUnicastAddress!)){
//                repeat{
//                    nextAvailableUnicastAddress += 1
//
//                }while meshNetwork.isAddressRangeValid(nextAvailableUnicastAddress!, elementsCount: 1)
//            }
            
            result(nextAvailableUnicastAddress)
            
        case .addProvisioner(let data):
            do {
                let provisionerUUID = UUID()
                
                let nextAvailableUnicastAddressRange = meshNetwork.nextAvailableUnicastAddressRange(ofSize: UInt16(data.unicastAddressRange))!
                let nextAvailableGroupAddressRange = meshNetwork.nextAvailableGroupAddressRange(ofSize: UInt16(data.groupAddressRange))!
                let nextAvailableSceneRange = meshNetwork.nextAvailableSceneRange(ofSize: UInt16(data.sceneAddressRange))!
                
                let mProvisioner = Provisioner.init(name: UIDevice.current.name, uuid: provisionerUUID, allocatedUnicastRange: [nextAvailableUnicastAddressRange], allocatedGroupRange: [nextAvailableGroupAddressRange], allocatedSceneRange: [nextAvailableSceneRange])
                
                try meshNetwork.add(provisioner: mProvisioner)
                
                let provisionerNode = meshNetwork.node(withUuid: provisionerUUID)
                provisionerNode?.defaultTTL = UInt8(data.globalTtl)
                result(true)
            } catch let error {
                print(error.localizedDescription)
            }

        }
    }
}

private extension DoozMeshNetwork{
    
    func _getMeshNetworkName() -> String?{
        return meshNetwork.meshName
    }
    
    func _getId() -> String?{
        return meshNetwork.uuid.uuidString
    }
    
}

public class CustomProvisioner : Codable{

    public let provisionerUuid: String
    public let lastSelected: Bool
    public let globalTtl: Int
    public let provisionerAddress: Int
//    public let uuid: UUID
    /// UTF-8 string, which should be a human readable name of the Provisioner.
    public var provisionerName: String
    /// An array of unicast range objects.
    public internal(set) var allocatedUnicastRanges: [AllocatedUnicastAndGroupRange]
    /// An array of group range objects.
    public internal(set) var allocatedGroupRanges:   [AllocatedUnicastAndGroupRange]
    /// An array of scene range objects.
    public internal(set) var allocatedSceneRanges:   [AllocatedSceneRange]

    init(name: String,
         uuid: String, globalTtl : Int,
         unicastAddress: Int,
         isLocal: Bool,
         allocatedUnicastRange: [AllocatedUnicastAndGroupRange],
         allocatedGroupRange:   [AllocatedUnicastAndGroupRange],
         allocatedSceneRange:   [AllocatedSceneRange]) {
        self.provisionerName = name
        self.provisionerUuid = uuid
        self.globalTtl = globalTtl
        self.provisionerAddress = unicastAddress
        self.lastSelected = isLocal
        self.allocatedUnicastRanges = allocatedUnicastRange
        self.allocatedGroupRanges   = allocatedGroupRange
        self.allocatedSceneRanges   = allocatedSceneRange

    }
}

public class AllocatedUnicastAndGroupRange: Codable{
    public var lowAddress: UInt16
    public var highAddress: UInt16
    init(lowAddress: UInt16, highAddress: UInt16 ) {
        self.lowAddress = lowAddress
        self.highAddress = highAddress
    }
}

public class AllocatedSceneRange: Codable{
    public var firstScene: UInt16
    public var lastScene: UInt16
    init(firstScene: UInt16, lastScene: UInt16 ) {
        self.firstScene = firstScene
        self.lastScene = lastScene
    }
}

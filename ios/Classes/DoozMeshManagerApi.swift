//
//  DoozMeshManagerApi.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 29/05/2020.
//

import Foundation
import nRFMeshProvision

enum DoozManagerApiChannel: String{
    case loadMeshNetwork
    case importMeshNetworkJson
    case deleteMeshNetworkFromDb
    case exportMeshNetwork
}

class DoozMeshManagerApi: NSObject{
    
    //MARK: Public properties
    let meshNetworkManager = MeshNetworkManager()
    
    //MARK: Private properties
    private var doozMeshNetwork: DoozMeshNetwork?
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        _initMeshNetworkManager()
        _initChannels(messenger: messenger)
    }
    
}


private extension DoozMeshManagerApi{
    
    func _initMeshNetworkManager(){
        meshNetworkManager.delegate = self
        
        meshNetworkManager.acknowledgmentTimerInterval = 0.150
        meshNetworkManager.transmissionTimerInteral = 0.600
        meshNetworkManager.incompleteMessageTimeout = 10.0
        meshNetworkManager.retransmissionLimit = 2
        meshNetworkManager.acknowledgmentMessageInterval = 4.2
        
        // As the interval has been increased, the timeout can be adjusted.
        // The acknowledged message will be repeated after 4.2 seconds,
        // 12.6 seconds (4.2 + 4.2 * 2), and 29.4 seconds (4.2 + 4.2 * 2 + 4.2 * 4).
        // Then, leave 10 seconds for until the incomplete message times out.
        meshNetworkManager.acknowledgmentMessageTimeout = 40.0

    }
    
    func _initChannels(messenger: FlutterBinaryMessenger){
        FlutterEventChannel(name: "\(namespace)/mesh_manager_api/events", binaryMessenger: messenger)
            .setStreamHandler(self)
        
        FlutterMethodChannel(name: "\(namespace)/mesh_manager_api/methods", binaryMessenger: messenger).setMethodCallHandler({ (call, result) in
            self._handleMethodCall(call, result: result)
        })
        
    }
    
    func _handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [DoozMeshManagerApi] Received flutter call : \(call.method)")
        guard let _method = DoozManagerApiChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }
        
        switch _method {
            
        case .loadMeshNetwork:
            _loadMeshNetwork()
            result(nil)
            break
        case .importMeshNetworkJson:
            if let _args = call.arguments as? [String:Any], let _json = _args["json"] as? String{
                _importMeshNetworkJson(_json)
            }
            break
        case .deleteMeshNetworkFromDb:
            if let _args = call.arguments as? [String:Any], let _id = _args["id"] as? String{
                _deleteMeshNetworkFromDb(_id)
            }
            break
        case .exportMeshNetwork:
            if let json = _exportMeshNetwork(){
                result(json)
            }
            break
        }

    }
    
    func _loadMeshNetwork(){
        
        do{
            _ = try meshNetworkManager.load()
            
        }catch{

            #warning("should we create a meshNetwork on load if meshNetworkManager.load() fails ?")
            //            let provisioner = Provisioner(name: UIDevice.current.name,
            //                                          allocatedUnicastRange: [AddressRange(0x0001...0x199A)],
            //                                          allocatedGroupRange:   [AddressRange(0xC000...0xCC9A)],
            //                                          allocatedSceneRange:   [SceneRange(0x0001...0x3333)])
            //            _ = meshNetworkManager.createNewMeshNetwork(withName: "DOOZ Mesh Network", by: provisioner)
            //            _ = meshNetworkManager.save()
            
            print(error)
        }
        
    }
    
    func _importMeshNetworkJson(_ json: String){
        do{
            if let data = json.data(using: .utf8){
                _ = try meshNetworkManager.import(from: data)
            }
        }catch{
            
            print(error)
        }
    }
    
    func _deleteMeshNetworkFromDb(_ id: String){
        #warning("Not fully implemented")
        if meshNetworkManager.meshNetwork?.id == id{
            let network = doozMeshNetwork
            #warning("no delete method on ios ?")
            // See https://github.com/NordicSemiconductor/IOS-nRF-Mesh-Library/issues/279
        }
        
//        if (mMeshManagerApi.meshNetwork?.id == meshNetworkId) {
//            val meshNetwork: MeshNetwork = doozMeshNetwork!!.meshNetwork
//            mMeshManagerApi.deleteMeshNetworkFromDb(meshNetwork)
//        }
    }
    
    func _exportMeshNetwork() -> String?{
        
        let data = meshNetworkManager.export()
        let str = String(decoding: data, as: UTF8.self)

        if str != ""{
            return str
        }
        
        return nil
        
    }
    
}


extension DoozMeshManagerApi: MeshNetworkDelegate{
    
    func meshNetworkManager(_ manager: MeshNetworkManager, didReceiveMessage message: MeshMessage, sentFrom source: Address, to destination: Address) {
        
    }
    
}


extension DoozMeshManagerApi: FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
}

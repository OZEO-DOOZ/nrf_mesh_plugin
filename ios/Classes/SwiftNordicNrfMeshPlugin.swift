import Flutter
import UIKit

enum PluginMethod: String{
    case getPlatformVersion
    case createMeshManagerApi
    case loadMeshNetwork
}

public class SwiftNordicNrfMeshPlugin: NSObject, FlutterPlugin {
    
    var meshManager: DoozMeshManager?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fr.dooz.nordic_nrf_mesh/methods", binaryMessenger: registrar.messenger())
        let instance = SwiftNordicNrfMeshPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        guard let _method = PluginMethod(rawValue: call.method) else{
            print("Method - \(call.method) - isn't handled in enum")
            return
        }

        switch _method {
        case .getPlatformVersion:
            #warning("why not working ?")
            result("iOS " + UIDevice.current.systemVersion)
            break
        case .createMeshManagerApi:
            
         //   self.meshManager = DoozMeshManager()
            result(nil)
            
            break
            
        case .loadMeshNetwork:
            _loadMeshNetwork(result)
            print("loadMeshNetwork")
            
        }
                
    }
}

private extension SwiftNordicNrfMeshPlugin{
    func _loadMeshNetwork(_ result: FlutterResult){
        guard let _meshManager = self.meshManager else{
            print("meshManager has not been initialized")
            return
        }
        
        _meshManager.loadMeshNetwork(result)
        
        #warning("Working here, we need to see with kevin how it works")
//        GlobalScope.launch {
//            val meshNetwork = onNetworkLoadedChannel.receive()
//            uiThreadHandler.post {
//                result.success(mapOf(
//                    "meshName" to meshNetwork?.meshName,
//                    "id" to meshNetwork?.id,
//                    "isLastSelected" to meshNetwork?.isLastSelected
//                ))
//
//            }
//        }
    }
}

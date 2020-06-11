import Flutter
import UIKit

public class SwiftNordicNrfMeshPlugin: NSObject, FlutterPlugin {
    
    //MARK: Public properties
    var meshManagerApi: DoozMeshManagerApi?
    var messenger: FlutterBinaryMessenger?
    
    //MARK: Private properties
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let pluginMethodChannel = FlutterMethodChannel(
            name: FlutterChannels.Plugin.getMethodChannelName(),
            binaryMessenger: registrar.messenger()
        )
        
        let instance = SwiftNordicNrfMeshPlugin()
        instance.messenger = registrar.messenger()
        registrar.addMethodCallDelegate(instance, channel: pluginMethodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [SwiftNordicNrfMeshPlugin] Received flutter call : \(call.method)")
        guard let _method = PluginMethodChannel(rawValue: call.method) else{
            print("❌ Plugin method - \(call.method) - isn't implemented")
            return
        }

        switch _method {
        case .getPlatformVersion:
            let systemVersion = "iOS " + UIDevice.current.systemVersion
            result(systemVersion)
            print("✅ Get Platform version returned \(systemVersion)")
            break
        case .createMeshManagerApi:
            guard let _messenger = self.messenger else{
                return
            }
            
            self.meshManagerApi = DoozMeshManagerApi(messenger: _messenger)
            print("✅ Mesh Manager Api object created")
            result(nil)
            
            break
            
        }
                
    }
}

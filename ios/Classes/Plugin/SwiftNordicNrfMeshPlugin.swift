import Flutter
import UIKit

public class SwiftNordicNrfMeshPlugin: NSObject, FlutterPlugin {
    
    //MARK: Public properties
    var meshManagerApi: DoozMeshManagerApi?
    var messenger: FlutterBinaryMessenger
    
    //MARK: Private properties
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let pluginMethodChannel = FlutterMethodChannel(
            name: FlutterChannels.Plugin.getMethodChannelName(),
            binaryMessenger: registrar.messenger()
        )
        
        let instance = SwiftNordicNrfMeshPlugin(messenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: pluginMethodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("🥂 [SwiftNordicNrfMeshPlugin] Received flutter call : \(call.method)")
        
        let _method = PluginMethodChannel(call: call)
        
        switch _method {
        case .error(let error):
            switch error {
            case FlutterCallError.notImplemented:
                result(FlutterMethodNotImplemented)
            default:
                #warning("manage other errors")
            }
        case .getPlatformVersion:
            let systemVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
            result(systemVersion)
            break
        case .createMeshManagerApi:
            self.meshManagerApi = DoozMeshManagerApi(messenger: messenger)
            result(nil)
            break
        }
        
    }
}

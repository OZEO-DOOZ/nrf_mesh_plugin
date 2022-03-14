import Flutter
import UIKit

public class SwiftNordicNrfMeshPlugin: NSObject, FlutterPlugin {
    
    //MARK: Public properties
    var meshManagerApi: DoozMeshManagerApi?
    var messenger: FlutterBinaryMessenger
    
    //MARK: Private properties
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        self.meshManagerApi = DoozMeshManagerApi(messenger: messenger)
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
            case FlutterCallError.missingArguments:
                result(FlutterError(code: "missingArguments", message: "The provided arguments does not match required", details: nil))
            case FlutterCallError.errorDecoding:
                result(FlutterError(code: "errorDecoding", message: "An error occured attempting to decode arguments", details: nil))
            default:
                let nsError = error as NSError
                result(FlutterError(code: String(nsError.code), message: nsError.localizedDescription, details: nil))
            }
            break
        case .getPlatformVersion:
            let systemVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
            result(systemVersion)
            break
    }
}

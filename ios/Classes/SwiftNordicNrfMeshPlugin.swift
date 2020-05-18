import Flutter
import UIKit

public class SwiftNordicNrfMeshPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nordic_nrf_mesh", binaryMessenger: registrar.messenger())
    let instance = SwiftNordicNrfMeshPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

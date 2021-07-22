package fr.dooz.nordic_nrf_mesh

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class NordicNrfMeshPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var methodChannel : MethodChannel
    private lateinit var flutterBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var binaryMessenger: BinaryMessenger
    private var meshManagerApi : DoozMeshManagerApi? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger
        methodChannel = MethodChannel(binaryMessenger, "$namespace/methods")
        flutterBinding = flutterPluginBinding;
        methodChannel.setMethodCallHandler(this);
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val methodChannel = MethodChannel(registrar.messenger(), "$namespace/methods")
            val nrfPlugin = NordicNrfMeshPlugin()
            methodChannel.setMethodCallHandler(nrfPlugin)
        }
    }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      when (call.method) {
          "getPlatformVersion" -> {
              result.success("Android ${android.os.Build.VERSION.RELEASE}")
          }
          "createMeshManagerApi" -> {
              meshManagerApi = DoozMeshManagerApi(flutterBinding.applicationContext,  binaryMessenger)
              result.success(null)
          }
          else -> {
              result.notImplemented()
          }
      }
  }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        //    TODO: we should clean meshManagerApi
    }
}


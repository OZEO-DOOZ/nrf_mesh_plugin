package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import no.nordicsemi.android.mesh.MeshManagerApi
import no.nordicsemi.android.mesh.MeshManagerCallbacks
import no.nordicsemi.android.mesh.MeshNetwork
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode


/** NordicNrfMeshPlugin */
public class NordicNrfMeshPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var methodChannel : MethodChannel
  private lateinit var flutterBinding: FlutterPlugin.FlutterPluginBinding
  private lateinit var meshManagerApi : DoozMeshManagerApi
  private lateinit var binaryMessenger: BinaryMessenger


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binaryMessenger = flutterPluginBinding.getFlutterEngine().getDartExecutor()
    methodChannel = MethodChannel(binaryMessenger, "$namespace/methods")
    flutterBinding = flutterPluginBinding;
    methodChannel.setMethodCallHandler(this);
  }

//  companion object {
//    @JvmStatic
//    fun registerWith(registrar: Registrar) {
//      val methodChannel = MethodChannel(registrar.messenger(), "$namespace/methods")
//      val eventChannel = EventChannel(registrar.messenger(), "$namespace/events")
//      val nrfPlugin = NordicNrfMeshPlugin()
//      methodChannel.setMethodCallHandler(nrfPlugin)
//    }
//  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "loadMeshNetwork" -> {
          meshManagerApi = DoozMeshManagerApi(flutterBinding.applicationContext, methodChannel, binaryMessenger);
          meshManagerApi.loadMeshNetwork()
          result.success(null)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }
}


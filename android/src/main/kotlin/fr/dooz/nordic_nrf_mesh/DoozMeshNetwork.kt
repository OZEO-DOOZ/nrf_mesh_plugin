package fr.dooz.nordic_nrf_mesh

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshNetwork

class DoozMeshNetwork(binaryMessenger: BinaryMessenger, var meshNetwork: MeshNetwork) : EventChannel.StreamHandler, MethodChannel.MethodCallHandler {
    private var eventSink : EventChannel.EventSink? = null
    private var eventChannel: EventChannel = EventChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/events")
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/events")

    init {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler(this)
    }

    private fun getId(): String? {
        return meshNetwork.id;
    }

    private fun getMeshNetworkName() : String {
        return meshNetwork.meshName;
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getId" -> {
                result.success(getId())
            }
            "getMeshNetworkName" -> {
                result.success(getMeshNetworkName())
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
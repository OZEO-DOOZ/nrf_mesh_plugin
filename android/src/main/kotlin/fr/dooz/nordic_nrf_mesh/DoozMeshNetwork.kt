package fr.dooz.nordic_nrf_mesh

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshNetwork

class DoozMeshNetwork(binaryMessenger: BinaryMessenger, var meshNetwork: MeshNetwork?) : EventChannel.StreamHandler, MethodChannel.MethodCallHandler {

    private  var eventSink : EventChannel.EventSink? = null

    init {
        EventChannel(binaryMessenger,"$namespace/mesh_network/events").setStreamHandler(this)
        MethodChannel(binaryMessenger,"$namespace/mesh_network/events").setMethodCallHandler(this)
    }

    private fun getId(): String? {
        return meshNetwork?.id;
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getId" -> {
                result.success(getId())
            }
        }
    }
}
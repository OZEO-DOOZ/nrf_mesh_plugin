package fr.dooz.nordic_nrf_mesh

import android.annotation.SuppressLint
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshNetwork
import java.lang.IllegalArgumentException

class DoozMeshNetwork(binaryMessenger: BinaryMessenger, var meshNetwork: MeshNetwork) : EventChannel.StreamHandler, MethodChannel.MethodCallHandler {
    private var eventSink : EventChannel.EventSink? = null
    private var eventChannel: EventChannel = EventChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/events")
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/methods")

    init {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler(this)
    }

    private fun getId(): String? {
        return meshNetwork.id
    }

    private fun getMeshNetworkName() : String {
        return meshNetwork.meshName
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    @SuppressLint("RestrictedApi")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getId" -> {
                result.success(getId())
            }
            "getMeshNetworkName" -> {
                result.success(getMeshNetworkName())
            }
            "nextAvailableUnicastAddress" -> {
                result.success(meshNetwork.nextAvailableUnicastAddress(call.argument<Int>("elementSize")!!, meshNetwork.selectedProvisioner))
            }
            "assignUnicastAddress" -> {
                try {
                    meshNetwork.assignUnicastAddress(call.argument<Int>("unicastAddress")!!)
                    result.success(null)
                } catch (e: IllegalArgumentException) {
                    result.error("ASSIGN_UNICAST_ADDRESS", "Failed to assign unicast address", e)
                }
            }
            "highestAllocatableAddress" -> {
                var maxAddress = 0;
                for (addressRange in meshNetwork.selectedProvisioner.allocatedUnicastRanges) {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = addressRange.highAddress
                    }
                }
                result.success(maxAddress)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
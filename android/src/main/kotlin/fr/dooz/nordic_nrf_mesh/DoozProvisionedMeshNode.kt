package fr.dooz.nordic_nrf_mesh

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.transport.ProvisionedMeshNode

class DoozProvisionedMeshNode(binaryMessenger: BinaryMessenger, var meshNode: ProvisionedMeshNode): MethodChannel.MethodCallHandler {
    init {
        MethodChannel(binaryMessenger, "$namespace/provisioned_mesh_node/${meshNode.uuid}/methods").setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "unicastAddress" -> {
                result.success(meshNode.unicastAddress)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
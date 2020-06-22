package fr.dooz.nordic_nrf_mesh

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode

class DoozUnprovisionedMeshNode(binaryMessenger: BinaryMessenger, var meshNode: UnprovisionedMeshNode) :MethodChannel.MethodCallHandler {
    init {
        MethodChannel(binaryMessenger, "$namespace/unprovisioned_mesh_node/${meshNode.deviceUuid}/methods").setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getNumberOfElements" -> {
                result.success(meshNode.numberOfElements)
            }
            "setUnicastAddress" -> {
                meshNode.unicastAddress = call.argument<Int>("unicastAddress")!!
                result.success(null)
            }
        }
    }
}
package fr.dooz.nordic_nrf_mesh

import android.annotation.SuppressLint
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshProvisioningStatusCallbacks
import no.nordicsemi.android.mesh.provisionerstates.ProvisioningState
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode
import no.nordicsemi.android.mesh.transport.ProvisionedMeshNode

class DoozMeshProvisioningStatusCallbacks(var binaryMessenger: BinaryMessenger, var eventSink : EventChannel.EventSink?, var unprovisionedMeshNodes: ArrayList<DoozUnprovisionedMeshNode>, var doozMeshManagerApi: DoozMeshManagerApi) : MeshProvisioningStatusCallbacks {
    override fun onProvisioningStateChanged(meshNode: UnprovisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningStateChanged ${meshNode?.deviceUuid?.toString()}")
        val meshNodeAlreadySaved = unprovisionedMeshNodes.any { it ->
            it.meshNode.deviceUuid == meshNode?.deviceUuid
        }
        Log.d(this.javaClass.name, "meshNodeAlreadySaved ${meshNodeAlreadySaved}")
        if (meshNode != null && !meshNodeAlreadySaved) {
            unprovisionedMeshNodes.add(DoozUnprovisionedMeshNode(binaryMessenger, meshNode))
        }

        val map = mapOf(
                "eventName" to "onProvisioningStateChanged",
                "state" to state?.name,
                "data" to data,
                "meshNode" to mapOf(
                        "uuid" to meshNode?.deviceUuid?.toString(),
                        "provisionerPublicKeyXY" to meshNode?.provisionerPublicKeyXY
                )
        )
        eventSink?.success(map)
    }

    override fun onProvisioningFailed(meshNode: UnprovisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningFailed")
        eventSink?.success(mapOf(
                "eventName" to "onProvisioningFailed",
                "state" to state?.name,
                "data" to data,
                "meshNode" to mapOf(
                        "uuid" to meshNode?.deviceUuid?.toString(),
                        "provisionerPublicKeyXY" to meshNode?.provisionerPublicKeyXY
                )
            )
        )
    }

    override fun onProvisioningCompleted(meshNode: ProvisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningCompleted")
        eventSink?.success(mapOf(
                "eventName" to "onProvisioningCompleted",
                "state" to state?.name,
                "data" to data,
                "meshNode" to mapOf(
                        "uuid" to meshNode?.uuid
                )
            )
        )
        doozMeshManagerApi.currentProvisionedMeshNode = DoozProvisionedMeshNode(binaryMessenger, meshNode!!)
    }

    @SuppressLint("RestrictedApi")
    fun getHighestAllocatableAddress(): Int {
        var maxAddress = 0
        for (addressRange in doozMeshManagerApi.mMeshManagerApi.meshNetwork!!.selectedProvisioner!!.allocatedUnicastRanges) {
            if (maxAddress < addressRange.highAddress) {
                maxAddress = addressRange.highAddress
            }
        }
        return maxAddress
    }

}
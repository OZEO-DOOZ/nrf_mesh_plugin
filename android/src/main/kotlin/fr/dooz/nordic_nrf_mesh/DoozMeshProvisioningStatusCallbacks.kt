package fr.dooz.nordic_nrf_mesh

import android.util.Log
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshProvisioningStatusCallbacks
import no.nordicsemi.android.mesh.provisionerstates.ProvisioningState
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode
import no.nordicsemi.android.mesh.transport.ProvisionedMeshNode

class DoozMeshProvisioningStatusCallbacks(var eventSink : EventChannel.EventSink?) : MeshProvisioningStatusCallbacks {
    override fun onProvisioningStateChanged(meshNode: UnprovisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningStateChanged")
    }

    override fun onProvisioningFailed(meshNode: UnprovisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningFailed")
    }

    override fun onProvisioningCompleted(meshNode: ProvisionedMeshNode?, state: ProvisioningState.States?, data: ByteArray?) {
        Log.d(this.javaClass.name, "onProvisioningCompleted")
    }

}
package fr.dooz.nordic_nrf_mesh

import android.util.Log
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshStatusCallbacks
import no.nordicsemi.android.mesh.transport.ControlMessage
import no.nordicsemi.android.mesh.transport.MeshMessage

class DoozMeshStatusCallbacks(var eventSink : EventChannel.EventSink?): MeshStatusCallbacks {
    override fun onMeshMessageProcessed(dst: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageProcessed")
    }

    override fun onMeshMessageReceived(src: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageReceived")
        eventSink?.success(mapOf(
                "eventName" to "onMeshMessageReceived",
                "src" to src,
                "meshMessage" to mapOf(
                        "src" to meshMessage.src,
                        "aszmic" to meshMessage.aszmic,
                        "dst" to meshMessage.dst
                )
        ))
    }

    override fun onUnknownPduReceived(src: Int, accessPayload: ByteArray?) {
        Log.d("DoozMeshStatusCallbacks", "onUnknownPduReceived")
    }

    override fun onTransactionFailed(dst: Int, hasIncompleteTimerExpired: Boolean) {
        Log.d("DoozMeshStatusCallbacks", "onTransactionFailed")
    }

    override fun onBlockAcknowledgementProcessed(dst: Int, message: ControlMessage) {
        Log.d("DoozMeshStatusCallbacks", "onBlockAcknowledgementProcessed")
    }

    override fun onBlockAcknowledgementReceived(src: Int, message: ControlMessage) {
        Log.d("DoozMeshStatusCallbacks", "onBlockAcknowledgementReceived")
    }

    override fun onMessageDecryptionFailed(meshLayer: String?, errorMessage: String?) {
        Log.d("DoozMeshStatusCallbacks", "onMessageDecryptionFailed")
    }
}
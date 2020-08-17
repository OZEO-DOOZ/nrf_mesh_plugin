package fr.dooz.nordic_nrf_mesh

import android.util.Log
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshManagerApi
import no.nordicsemi.android.mesh.MeshStatusCallbacks
import no.nordicsemi.android.mesh.transport.*

class DoozMeshStatusCallbacks(var eventSink : EventChannel.EventSink?, var meshManagerApi: MeshManagerApi): MeshStatusCallbacks {
    override fun onMeshMessageProcessed(dst: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageProcessed")
    }

    override fun onMeshMessageReceived(src: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageReceived")

        if (meshMessage is ConfigCompositionDataStatus) {
            Log.d("DoozMeshStatusCallbacks", "ConfigCompositionDataStatus")

            eventSink?.success(mapOf(
                "eventName" to "onConfigCompositionDataStatus",
                "src" to src,
                "meshMessage" to mapOf(
                        "src" to meshMessage.src,
                        "aszmic" to meshMessage.aszmic,
                        "dst" to meshMessage.dst
                )
            ))
        } else if (meshMessage is ConfigAppKeyStatus) {
            eventSink?.success(mapOf(
                    "eventName" to "onConfigAppKeyStatus",
                    "src" to src,
                    "meshMessage" to mapOf(
                            "src" to meshMessage.src,
                            "aszmic" to meshMessage.aszmic,
                            "dst" to meshMessage.dst
                    )
            ))
        } else if (meshMessage is GenericOnOffStatus) {
            eventSink?.success(mapOf(
                    "eventName" to "onGenericOnOffStatus",
                    "source" to meshMessage.src,
                    "presentState" to meshMessage.presentState,
                    "targetState" to meshMessage.targetState,
                    "transitionResolution" to meshMessage.transitionResolution,
                    "transitionSteps" to meshMessage.transitionSteps
            ))
        } else if (meshMessage is GenericLevelStatus) {
            eventSink?.success(mapOf(
                    "eventName" to "onGenericLevelStatus",
                    "level" to meshMessage.presentLevel,
                    "targetLevel" to meshMessage.targetLevel,
                    "source" to meshMessage.src
            ))
        } else {
            Log.d("DoozMeshStatusCallbacks", meshMessage.javaClass.toString())
        }
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
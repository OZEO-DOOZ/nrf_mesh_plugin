package fr.dooz.nordic_nrf_mesh

import android.util.Log
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshStatusCallbacks
import no.nordicsemi.android.mesh.transport.*

class DoozMeshStatusCallbacks(var eventSink : EventChannel.EventSink?): MeshStatusCallbacks {
    override fun onMeshMessageProcessed(dst: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageProcessed")
    }

    override fun onMeshMessageReceived(src: Int, meshMessage: MeshMessage) {
        Log.d("DoozMeshStatusCallbacks", "onMeshMessageReceived")

        when (meshMessage) {
            is ConfigCompositionDataStatus -> {
                Log.d("DoozMeshStatusCallbacks", "ConfigCompositionDataStatus")

                eventSink?.success(mapOf(
                        "eventName" to "onConfigCompositionDataStatus",
                        "source" to src,
                        "meshMessage" to mapOf(
                                "source" to meshMessage.src,
                                "destination" to meshMessage.dst
                        )
                ))
            }
            is ConfigAppKeyStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onConfigAppKeyStatus",
                        "source" to src,
                        "meshMessage" to mapOf(
                                "source" to meshMessage.src,
                                "destination" to meshMessage.dst
                        )
                ))
            }
            is GenericOnOffStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onGenericOnOffStatus",
                        "source" to meshMessage.src,
                        "presentState" to meshMessage.presentState,
                        "targetState" to meshMessage.targetState,
                        "transitionResolution" to meshMessage.transitionResolution,
                        "transitionSteps" to meshMessage.transitionSteps
                ))
            }
            is GenericLevelStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onGenericLevelStatus",
                        "level" to meshMessage.presentLevel,
                        "targetLevel" to meshMessage.targetLevel,
                        "source" to meshMessage.src,
                        "destination" to meshMessage.dst
                ))
            }
            is ConfigModelAppStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onConfigModelAppStatus",
                        "elementAddress" to meshMessage.elementAddress,
                        "modelId" to meshMessage.modelIdentifier,
                        "appKeyIndex" to meshMessage.appKeyIndex
                ))
            }
            is ConfigModelSubscriptionStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onConfigModelSubscriptionStatus",
                        "source" to meshMessage.src,
                        "destination" to meshMessage.dst,
                        "elementAddress" to meshMessage.elementAddress,
                        "subscriptionAddress" to meshMessage.subscriptionAddress,
            is ConfigModelPublicationStatus -> {
                eventSink?.success(mapOf(
                        "eventName" to "onConfigModelPublicationStatus",
                        "elementAddress" to meshMessage.elementAddress,
                        "publishAddress" to meshMessage.publishAddress,
                        "appKeyIndex" to meshMessage.appKeyIndex,
                        "credentialFlag" to meshMessage.credentialFlag,
                        "publishTtl" to meshMessage.publishTtl,
                        "publicationSteps" to meshMessage.publicationSteps,
                        "publicationResolution" to meshMessage.publicationResolution,
                        "retransmitCount" to meshMessage.publishRetransmitCount,
                        "retransmitIntervalSteps" to meshMessage.publishRetransmitIntervalSteps,
                        "modelIdentifier" to meshMessage.modelIdentifier,
                        "isSuccessful" to meshMessage.isSuccessful
                ))
            }
            else -> {
                Log.d("DoozMeshStatusCallbacks", meshMessage.javaClass.toString())
            }
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
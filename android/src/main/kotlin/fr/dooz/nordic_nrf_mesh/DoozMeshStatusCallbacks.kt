package fr.dooz.nordic_nrf_mesh

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshStatusCallbacks
import no.nordicsemi.android.mesh.transport.*

class DoozMeshStatusCallbacks(var eventSink: EventChannel.EventSink?): MeshStatusCallbacks {
    private val TAG: String = DoozMeshStatusCallbacks::class.java.simpleName

    override fun onMeshMessageProcessed(dst: Int, meshMessage: MeshMessage) {
        Log.d(TAG, "onMeshMessageProcessed to " + dst.toString())
    }

    override fun onMeshMessageReceived(src: Int, meshMessage: MeshMessage) {
        Log.d(TAG, "onMeshMessageReceived")

        when (meshMessage) {
            is ConfigCompositionDataStatus -> {
                Log.d(TAG, "received a ConfigCompositionDataStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onConfigCompositionDataStatus",
                            "source" to src,
                            "meshMessage" to mapOf(
                                    "source" to meshMessage.src,
                                    "destination" to meshMessage.dst
                            )
                    ))
                }
            }
            is ConfigAppKeyStatus -> {
                Log.d(TAG, "received a ConfigAppKeyStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onConfigAppKeyStatus",
                            "source" to src,
                            "meshMessage" to mapOf(
                                    "source" to meshMessage.src,
                                    "destination" to meshMessage.dst
                            )
                    ))
                }
            }
            is GenericOnOffStatus -> {
                Log.d(TAG, "received a GenericOnOffStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onGenericOnOffStatus",
                            "source" to meshMessage.src,
                            "presentState" to meshMessage.presentState,
                            "targetState" to meshMessage.targetState,
                            "transitionResolution" to meshMessage.transitionResolution,
                            "transitionSteps" to meshMessage.transitionSteps
                    ))
                }
            }
            is GenericLevelStatus -> {
                Log.d(TAG, "received a GenericLevelStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onGenericLevelStatus",
                            "level" to meshMessage.presentLevel,
                            "targetLevel" to meshMessage.targetLevel,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is MagicLevelSetStatus -> {
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onMagicLevelSetStatus",
                            "io" to meshMessage.io,
                            "index" to meshMessage.index,
                            "value" to meshMessage.value,
                            "correlation" to meshMessage.correlation,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is MagicLevelGetStatus -> {
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onMagicLevelGetStatus",
                            "io" to meshMessage.io,
                            "index" to meshMessage.index,
                            "value" to meshMessage.value,
                            "correlation" to meshMessage.correlation,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is ConfigModelAppStatus -> {
                Log.d(TAG, "received a ConfigModelAppStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onConfigModelAppStatus",
                            "elementAddress" to meshMessage.elementAddress,
                            "modelId" to meshMessage.modelIdentifier,
                            "appKeyIndex" to meshMessage.appKeyIndex
                    ))
                }
            }
            is ConfigModelSubscriptionStatus -> {
                Log.d(TAG, "received a ConfigModelSubscriptionStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onConfigModelSubscriptionStatus",
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst,
                            "elementAddress" to meshMessage.elementAddress,
                            "subscriptionAddress" to meshMessage.subscriptionAddress,
                            "modelIdentifier" to meshMessage.modelIdentifier,
                            "isSuccessful" to meshMessage.isSuccessful
                    ))
                }
            }
            is ConfigModelPublicationStatus -> {
                Log.d(TAG, "received a ConfigModelPublicationStatus")
                Handler(Looper.getMainLooper()).post {
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
            }
            is LightLightnessStatus -> {
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onLightLightnessStatus",
                            "presentLightness" to meshMessage.presentLightness,
                            "targetLightness" to meshMessage.targetLightness,
                            "transitionSteps" to meshMessage.transitionSteps,
                            "transitionResolution" to meshMessage.transitionResolution,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is LightCtlStatus -> {
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onLightCtlStatus",
                            "presentLightness" to meshMessage.presentLightness,
                            "targetLightness" to meshMessage.targetLightness,
                            "presentTemperature" to meshMessage.presentTemperature,
                            "targetTemperature" to meshMessage.targetTemperature,
                            "transitionSteps" to meshMessage.transitionSteps,
                            "transitionResolution" to meshMessage.transitionResolution,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is LightHslStatus -> {
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onLightHslStatus",
                            "presentLightness" to meshMessage.presentLightness,
                            "presentHue" to meshMessage.presentHue,
                            "presentSaturation" to meshMessage.presentSaturation,
                            "transitionSteps" to meshMessage.transitionSteps,
                            "transitionResolution" to meshMessage.transitionResolution,
                            "source" to meshMessage.src,
                            "destination" to meshMessage.dst
                    ))
                }
            }
            is ConfigNodeResetStatus -> {
                Log.d(TAG, "received a ConfigNodeResetStatus")
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(mapOf(
                            "eventName" to "onConfigNodeResetStatus",
                            "source" to meshMessage.src,
                            "success" to true,
                    ))
                }
            }
            else -> {
                Log.d(TAG, "Unknown message received :" + meshMessage.javaClass.toString())
            }
        }
    }

    override fun onUnknownPduReceived(src: Int, accessPayload: ByteArray?) {
        Log.d(TAG, "onUnknownPduReceived")
    }

    override fun onTransactionFailed(dst: Int, hasIncompleteTimerExpired: Boolean) {
        Log.d(TAG, "onTransactionFailed")
    }

    override fun onBlockAcknowledgementProcessed(dst: Int, message: ControlMessage) {
        Log.d(TAG, "onBlockAcknowledgementProcessed")
    }

    override fun onBlockAcknowledgementReceived(src: Int, message: ControlMessage) {
        Log.d(TAG, "onBlockAcknowledgementReceived")
    }

    override fun onMessageDecryptionFailed(meshLayer: String?, errorMessage: String?) {
        Log.d(TAG, "onMessageDecryptionFailed")
    }
}
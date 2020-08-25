package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshManagerApi
import no.nordicsemi.android.mesh.MeshNetwork
import no.nordicsemi.android.mesh.Provisioner
import no.nordicsemi.android.mesh.transport.*
import java.util.*
import kotlin.collections.ArrayList


class DoozMeshManagerApi(context: Context, binaryMessenger: BinaryMessenger) : StreamHandler, MethodChannel.MethodCallHandler {
    var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink :EventSink? = null
    private var doozMeshNetwork: DoozMeshNetwork? = null
    val doozMeshManagerCallbacks: DoozMeshManagerCallbacks
    val doozMeshProvisioningStatusCallbacks: DoozMeshProvisioningStatusCallbacks
    var doozMeshStatusCallbacks: DoozMeshStatusCallbacks
    val unprovisionedMeshNodes: ArrayList<DoozUnprovisionedMeshNode> = ArrayList()
    var currentProvisionedMeshNode: DoozProvisionedMeshNode? = null

    init {
        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)

        doozMeshManagerCallbacks = DoozMeshManagerCallbacks(binaryMessenger, eventSink)
        doozMeshProvisioningStatusCallbacks = DoozMeshProvisioningStatusCallbacks(binaryMessenger, eventSink, unprovisionedMeshNodes, this)
        doozMeshStatusCallbacks = DoozMeshStatusCallbacks(eventSink)

        mMeshManagerApi.setMeshManagerCallbacks(doozMeshManagerCallbacks)
        mMeshManagerApi.setProvisioningStatusCallbacks(doozMeshProvisioningStatusCallbacks)
        mMeshManagerApi.setMeshStatusCallbacks(doozMeshStatusCallbacks)
    }

    private fun loadMeshNetwork()  {
        mMeshManagerApi.loadMeshNetwork()
    }

    private fun handleNotifications(mtu: Int, pdu: ByteArray) {
        mMeshManagerApi.handleNotifications(mtu, pdu)
    }

    private fun handleWriteCallbacks(mtu: Int, pdu: ByteArray) {
        mMeshManagerApi.handleWriteCallbacks(mtu, pdu)
    }

    private fun importMeshNetworkJson(json: String) {
        mMeshManagerApi.importMeshNetworkJson(json)
    }

    private fun exportMeshNetwork(): String? {
        return mMeshManagerApi.exportMeshNetwork()
    }

    private fun deleteMeshNetworkFromDb(meshNetworkId: String) {
        if (mMeshManagerApi.meshNetwork?.id == meshNetworkId) {
            val meshNetwork: MeshNetwork = doozMeshNetwork!!.meshNetwork
            mMeshManagerApi.deleteMeshNetworkFromDb(meshNetwork)
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        Log.d(this.javaClass.name, "onListen $arguments $events")
        this.eventSink = events
        doozMeshManagerCallbacks.eventSink = eventSink
        doozMeshProvisioningStatusCallbacks.eventSink = eventSink
        doozMeshStatusCallbacks.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        doozMeshManagerCallbacks.eventSink = null
        doozMeshProvisioningStatusCallbacks.eventSink = null
        doozMeshStatusCallbacks.eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadMeshNetwork" -> {
                loadMeshNetwork()
                result.success(null)
            }
            "importMeshNetworkJson" -> {
                importMeshNetworkJson(call.argument<String>("json")!!)
                result.success(null)
            }
            "deleteMeshNetworkFromDb" -> {
                deleteMeshNetworkFromDb(call.argument<String>("id")!!)
                result.success(null)
            }
            "exportMeshNetwork" -> {
                val json = exportMeshNetwork()
                result.success(json)
            }
            "resetMeshNetwork" -> {
                mMeshManagerApi.resetMeshNetwork()
                result.success(null)
            }
            "identifyNode" -> {
                mMeshManagerApi.identifyNode(UUID.fromString(call.argument<String>("serviceUuid")!!))
                result.success(null);
            }
            "sendConfigModelAppBind" -> {
                val nodeId = call.argument<Int>("nodeId")!!
                val elementId = call.argument<Int>("elementId")!!
                val modelId = call.argument<Int>("modelId")!!
                val appKeyIndex = call.argument<Int>("appKeyIndex")!!
                val configModelAppBind = ConfigModelAppBind(elementId, modelId, appKeyIndex)
                mMeshManagerApi.createMeshPdu(nodeId, configModelAppBind)
                result.success(null)
            }
            "sendGenericLevelSet" -> {
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val address = call.argument<Int>("address")!!
                val level = call.argument<Int>("level")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val transitionStep = call.argument<Int>("transitionStep")
                val transitionResolution = call.argument<Int>("transitionResolution")
                val delay = call.argument<Int>("delay")
                val meshMessage: MeshMessage = GenericLevelSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        transitionStep,
                        transitionResolution,
                        delay,
                        level,
                        sequenceNumber
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "sendGenericOnOffSet" -> {
                val address = call.argument<Int>("address")!!
                val value = call.argument<Boolean>("value")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val meshMessage: MeshMessage = GenericOnOffSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        value,
                        mMeshManagerApi.meshNetwork!!.sequenceNumbers.get(address),
                        null,
                        null,
                        null
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "sendConfigModelSubscriptionDelete" -> {
                val address = call.argument<Int>("address")!!
                val elementAddress = call.argument<Int>("elementAddress")!!
                val subscriptionAddress = call.argument<Int>("subscriptionAddress")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!
                val meshMessage = ConfigModelSubscriptionDelete(elementAddress, subscriptionAddress, modelIdentifier)
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "getDeviceUuid" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!;
                result.success(mMeshManagerApi.getDeviceUuid(serviceData).toString());
            }
            "handleNotifications" -> {
                val pdu = call.argument<ByteArray>("pdu")!!;
                handleNotifications(call.argument<Int>("mtu")!!, pdu)
                result.success(null)
            }
            "handleWriteCallbacks" -> {
                val pdu = call.argument<ArrayList<Int>>("pdu")!!
                handleWriteCallbacks(call.argument<Int>("mtu")!!, arrayListToByteArray(pdu))
                result.success(null)
            }
            "cleanProvisioningData" -> {
                unprovisionedMeshNodes.clear()
                currentProvisionedMeshNode = null
                result.success(null)
            }
            "provisioning" -> {
                val uuid = UUID.fromString(call.argument("uuid")!!);
                val unprovisionedMeshNode = unprovisionedMeshNodes.firstOrNull() { it.meshNode.deviceUuid == uuid }
                if (unprovisionedMeshNode == null) {
                    result.error("NOT_FOUND", "MeshNode with uuid ${uuid.toString()} doesn't exist", null)
                    return
                }
                mMeshManagerApi.startProvisioning(unprovisionedMeshNode.meshNode)
                result.success(null)
            }
            "createMeshPduForConfigCompositionDataGet" -> {
                mMeshManagerApi.createMeshPdu(call.argument("dest")!!, ConfigCompositionDataGet())
                result.success(null)
            }
            "createMeshPduForConfigAppKeyAdd" -> {
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val configAppKeyAdd = ConfigAppKeyAdd(currentMeshNetwork.netKeys[0], currentMeshNetwork.appKeys[0])
                mMeshManagerApi.createMeshPdu(call.argument("dest")!!, configAppKeyAdd)
                result.success(null)
            }
            "setMtuSize" -> {
                doozMeshManagerCallbacks.mtuSize = call.argument<Int>("mtuSize")!!
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}


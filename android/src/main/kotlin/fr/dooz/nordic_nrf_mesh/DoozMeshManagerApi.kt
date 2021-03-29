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
import no.nordicsemi.android.mesh.transport.*
import java.util.*
import kotlin.collections.ArrayList


class DoozMeshManagerApi(context: Context, binaryMessenger: BinaryMessenger) : StreamHandler, MethodChannel.MethodCallHandler {
    private var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink: EventSink? = null
    private var doozMeshNetwork: DoozMeshNetwork? = null
    private val doozMeshManagerCallbacks: DoozMeshManagerCallbacks
    private val doozMeshProvisioningStatusCallbacks: DoozMeshProvisioningStatusCallbacks
    private var doozMeshStatusCallbacks: DoozMeshStatusCallbacks
    private val unProvisionedMeshNodes: ArrayList<DoozUnprovisionedMeshNode> = ArrayList()
    var currentProvisionedMeshNode: DoozProvisionedMeshNode? = null
    private val tag: String = DoozMeshManagerApi::class.java.simpleName

    init {
        EventChannel(binaryMessenger, "$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)

        doozMeshManagerCallbacks = DoozMeshManagerCallbacks(binaryMessenger, eventSink)
        doozMeshProvisioningStatusCallbacks = DoozMeshProvisioningStatusCallbacks(binaryMessenger, eventSink, unProvisionedMeshNodes, this)
        doozMeshStatusCallbacks = DoozMeshStatusCallbacks(eventSink)

        mMeshManagerApi.setMeshManagerCallbacks(doozMeshManagerCallbacks)
        mMeshManagerApi.setProvisioningStatusCallbacks(doozMeshProvisioningStatusCallbacks)
        mMeshManagerApi.setMeshStatusCallbacks(doozMeshStatusCallbacks)
    }

    private fun loadMeshNetwork() {
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
        Log.d(tag, "onListen $arguments $events")
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
                result.success(null)
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
            "sendGenericLevelGet" -> {
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val meshMessage: MeshMessage = GenericLevelGet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex)
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "sendGenericOnOffSet" -> {
                val address = call.argument<Int>("address")!!
                val value = call.argument<Boolean>("value")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val transitionStep = call.argument<Int>("transitionStep")
                val transitionResolution = call.argument<Int>("transitionResolution")
                val delay = call.argument<Int>("delay")
                val meshMessage: MeshMessage = GenericOnOffSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        value,
                        sequenceNumber,
                        transitionStep,
                        transitionResolution,
                        delay
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "sendConfigModelSubscriptionAdd" -> {
                val elementAddress = call.argument<Int>("elementAddress")!!
                val subscriptionAddress = call.argument<Int>("subscriptionAddress")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val pNode: ProvisionedMeshNode = currentMeshNetwork.getNode(elementAddress)
                val meshMessage = ConfigModelSubscriptionAdd(elementAddress, subscriptionAddress, modelIdentifier)
                mMeshManagerApi.createMeshPdu(pNode.unicastAddress, meshMessage)
                result.success(null)
            }
            "sendConfigModelSubscriptionDelete" -> {
                val elementAddress = call.argument<Int>("elementAddress")!!
                val subscriptionAddress = call.argument<Int>("subscriptionAddress")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val pNode: ProvisionedMeshNode = currentMeshNetwork.getNode(elementAddress)
                val meshMessage = ConfigModelSubscriptionDelete(elementAddress, subscriptionAddress, modelIdentifier)
                mMeshManagerApi.createMeshPdu(pNode.unicastAddress, meshMessage)
                result.success(null)
            }
            "sendConfigModelSubscriptionDeleteAll" -> {
                val elementAddress = call.argument<Int>("elementAddress")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!
                val meshMessage = ConfigModelSubscriptionDeleteAll(elementAddress, modelIdentifier)
                mMeshManagerApi.createMeshPdu(elementAddress, meshMessage)
                result.success(null)
            }
            "sendConfigModelPublicationSet" -> {
                val elementAddress = call.argument<Int>("elementAddress")!!
                val publishAddress = call.argument<Int>("publishAddress")!!
                val appKeyIndex = call.argument<Int>("appKeyIndex")!!
                val credentialFlag = call.argument<Boolean>("credentialFlag")!!
                val publishTtl = call.argument<Int>("publishTtl")!!
                val publicationSteps = call.argument<Int>("publicationSteps")!!
                val publicationResolution = call.argument<Int>("publicationResolution")!!
                val retransmitCount = call.argument<Int>("retransmitCount")!!
                val retransmitIntervalSteps = call.argument<Int>("retransmitIntervalSteps")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val pNode: ProvisionedMeshNode = currentMeshNetwork.getNode(elementAddress)
                val meshMessage = ConfigModelPublicationSet(
                        elementAddress,
                        publishAddress,
                        appKeyIndex,
                        credentialFlag,
                        publishTtl,
                        publicationSteps,
                        publicationResolution,
                        retransmitCount,
                        retransmitIntervalSteps,
                        modelIdentifier
                )
                mMeshManagerApi.createMeshPdu(pNode.unicastAddress, meshMessage)
                result.success(null)
            }
            "sendV2MagicLevel" -> {
                val io = call.argument<Int>("io")!!
                val index = call.argument<Int>("index")!!
                val value = call.argument<Int>("value")!!
                val correlation = call.argument<Int>("correlation")!!
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val prov = mMeshManagerApi.meshNetwork!!.selectedProvisioner!!
                val pNode = mMeshManagerApi.meshNetwork!!.getNode(prov!!.provisionerUuid)
                val sequenceNumber = pNode!!.sequenceNumber
                val meshMessage = MagicLevelSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        io, index, value, correlation, sequenceNumber
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "getV2MagicLevel" -> {
                val io = call.argument<Int>("io")!!
                val index = call.argument<Int>("index")!!
                val correlation = call.argument<Int>("correlation")!!
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val meshMessage = MagicLevelGet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        io, index, correlation, sequenceNumber
                )
                mMeshManagerApi.createMeshPdu(address, meshMessage)
                result.success(null)
            }
            "sendLightLightness" -> {
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val lightness = call.argument<Int>("lightness")!!
                val lightnessSet = LightLightnessSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        lightness,
                        sequenceNumber)
                mMeshManagerApi.createMeshPdu(address, lightnessSet)
                result.success(null)
            }
            "sendLightCtl" -> {
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val lightness = call.argument<Int>("lightness")!!
                val temperature = call.argument<Int>("temperature")!!
                val lightDeltaUV = call.argument<Int>("lightDeltaUV")!!
                val lightCtlSet = LightCtlSet(
                        mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        lightness,
                        temperature,
                        lightDeltaUV,
                        sequenceNumber)
                mMeshManagerApi.createMeshPdu(address, lightCtlSet)
                result.success(null)
            }
            "sendLightHsl" -> {
                val sequenceNumber = call.argument<Int>("sequenceNumber")!!
                val address = call.argument<Int>("address")!!
                val keyIndex = call.argument<Int>("keyIndex")!!
                val lightness = call.argument<Int>("lightness")!!
                val hue = call.argument<Int>("hue")!!
                val saturation = call.argument<Int>("saturation")!!
                val lightHslSet = LightHslSet(mMeshManagerApi.meshNetwork!!.getAppKey(keyIndex),
                        lightness, hue, saturation, sequenceNumber)
                mMeshManagerApi.createMeshPdu(address, lightHslSet)
                result.success(null)
            }
            "getDeviceUuid" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!
                result.success(mMeshManagerApi.getDeviceUuid(serviceData).toString())
            }
            "handleNotifications" -> {
                val pdu = call.argument<ByteArray>("pdu")!!
                handleNotifications(call.argument<Int>("mtu")!!, pdu)
                result.success(null)
            }
            "handleWriteCallbacks" -> {
                val pdu = call.argument<ArrayList<Int>>("pdu")!!
                handleWriteCallbacks(call.argument<Int>("mtu")!!, arrayListToByteArray(pdu))
                result.success(null)
            }
            "cleanProvisioningData" -> {
                unProvisionedMeshNodes.clear()
                currentProvisionedMeshNode = null
                result.success(null)
            }
            "provisioning" -> {
                val uuid = UUID.fromString(call.argument("uuid")!!)
                val unProvisionedMeshNode = unProvisionedMeshNodes.firstOrNull { it.meshNode.deviceUuid == uuid }
                if (unProvisionedMeshNode == null) {
                    result.error("NOT_FOUND", "MeshNode with uuid $uuid doesn't exist", null)
                    return
                }
                mMeshManagerApi.startProvisioning(unProvisionedMeshNode.meshNode)
                result.success(null)
            }
            "cachedProvisionedMeshNodeUuid" -> {
                if (null == currentProvisionedMeshNode) {
                    result.success(null)
                } else {
                    val provisionedMeshNode = currentProvisionedMeshNode!!
                    result.success(provisionedMeshNode.meshNode.getUuid())
                }
            }
            "deprovision" -> {
                Log.d(tag, "should unprovision")
                try {
                    val unicastAddress = call.argument<Int>("unicastAddress")!!
                    val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                    val pNode: ProvisionedMeshNode = currentMeshNetwork.getNode(unicastAddress)
                    if (pNode == null) {
                        result.error("NOT_FOUND", "MeshNode with unicastAddress $unicastAddress doesn't exist", null)
                    } else {
                        val configNodeReset = ConfigNodeReset()
                        mMeshManagerApi.createMeshPdu(unicastAddress, configNodeReset)
                    }
                } catch (ex: Exception) {
                    Log.e(tag, ex.message)
                    result.success(false)
                }
                result.success(true)
            }
            "sendConfigCompositionDataGet" -> {
                mMeshManagerApi.createMeshPdu(call.argument("dest")!!, ConfigCompositionDataGet())
                result.success(null)
            }
            "sendConfigAppKeyAdd" -> {
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val configAppKeyAdd = ConfigAppKeyAdd(currentMeshNetwork.netKeys[0], currentMeshNetwork.appKeys[0])
                mMeshManagerApi.createMeshPdu(call.argument("dest")!!, configAppKeyAdd)
                result.success(null)
            }
            "setMtuSize" -> {
                doozMeshManagerCallbacks.mtuSize = call.argument<Int>("mtuSize")!!
                result.success(null)
            }
            "nodeIdentityMatches" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                currentMeshNetwork.nodes.forEach { node ->
                    if (mMeshManagerApi.nodeIdentityMatches(node, serviceData)) {
                        result.success(true)
                    }
                }
                result.success(false)
            }
            "networkIdMatches" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!
                val currentMeshNetwork = mMeshManagerApi.meshNetwork!!
                val networkKeys = currentMeshNetwork.getNetKeys()!!
                val networkId = mMeshManagerApi.generateNetworkId(networkKeys.get(0).getKey())
                var matches = mMeshManagerApi.networkIdMatches(networkId, serviceData)
                result.success(matches)
            }
            "isAdvertisingWithNetworkIdentity" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!
                try {
                    result.success(mMeshManagerApi.isAdvertisingWithNetworkIdentity(serviceData))
                } catch (e: Exception) {
                    result.error("101", e.message, "an error occured while checking service data")
                }
            }
            "isAdvertisedWithNodeIdentity" -> {
                val serviceData = call.argument<ByteArray>("serviceData")!!
                try {
                    result.success(mMeshManagerApi.isAdvertisedWithNodeIdentity(serviceData))
                } catch (e: Exception) {
                    result.error("102", e.message, "an error occured while checking service data")
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}


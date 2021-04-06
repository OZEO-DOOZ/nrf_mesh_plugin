package fr.dooz.nordic_nrf_mesh

import android.annotation.SuppressLint
import android.util.Log
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.*
import no.nordicsemi.android.mesh.transport.Element
import no.nordicsemi.android.mesh.transport.NodeDeserializer
import no.nordicsemi.android.mesh.transport.ProvisionedMeshNode
import java.lang.reflect.Type
import java.util.*


class DoozMeshNetwork(private val binaryMessenger: BinaryMessenger, var meshNetwork: MeshNetwork) : EventChannel.StreamHandler, MethodChannel.MethodCallHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var eventChannel: EventChannel = EventChannel(binaryMessenger, "$namespace/mesh_network/${meshNetwork.id}/events")
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger, "$namespace/mesh_network/${meshNetwork.id}/methods")
    private val tag: String = DoozMeshNetwork::class.java.simpleName

    init {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler(this)
    }

    private fun getId(): String? {
        return meshNetwork.id
    }

    private fun getMeshNetworkName(): String {
        return meshNetwork.meshName
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    //adding prov to mesh n/w
    private fun addProvisioner(provisioner: Provisioner): Boolean {
        return try {
            meshNetwork.addProvisioner(provisioner)
        } catch (e: java.lang.IllegalArgumentException) {
            Log.e(tag, "caught exception " + e.message)
            false
        }
    }

    @SuppressLint("RestrictedApi")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getId" -> {
                result.success(getId())
            }
            "getMeshNetworkName" -> {
                result.success(getMeshNetworkName())
            }
            "nextAvailableUnicastAddress" -> {
                result.success(meshNetwork.nextAvailableUnicastAddress(call.argument<Int>("elementSize")!!, meshNetwork.selectedProvisioner))
            }
            "assignUnicastAddress" -> {
                try {
                    meshNetwork.assignUnicastAddress(call.argument<Int>("unicastAddress")!!)
                    result.success(null)
                } catch (e: IllegalArgumentException) {
                    result.error("ASSIGN_UNICAST_ADDRESS", "Failed to assign unicast address", e)
                }
            }
            "selectProvisioner" -> {
                val provisionerIndex = call.argument<Int>("provisionerIndex")!!
                meshNetwork.selectProvisioner(meshNetwork.provisioners[provisionerIndex])
                result.success(null)
            }
            "getSequenceNumberForAddress" -> {
                val address = call.argument<Int>("address")!!
                result.success(meshNetwork.sequenceNumbers.get(address))
            }
            "addGroupWithName" -> {
                val groupName = call.argument<String>("name")!!
                val group = meshNetwork.createGroup(meshNetwork.selectedProvisioner, groupName)
                val success = meshNetwork.addGroup(group)
                result.success(mapOf(
                        "group" to mapOf(
                                "name" to group.name,
                                "address" to group.address,
                                "addressLabel" to group.addressLabel?.toString(),
                                "meshUuid" to group.meshUuid,
                                "parentAddress" to group.parentAddress,
                                "parentAddressLabel" to group.parentAddressLabel?.toString()
                        ),
                        "successfullyAdded" to success
                ))
            }
            "groups" -> {
                result.success(meshNetwork.groups.map {
                    mapOf(
                            "name" to it.name,
                            "address" to it.address,
                            "addressLabel" to it.addressLabel?.toString(),
                            "meshUuid" to it.meshUuid,
                            "parentAddress" to it.parentAddress,
                            "parentAddressLabel" to it.parentAddressLabel?.toString()

                    )
                }
                )
            }
            "removeGroup" -> {
                val groupAddress = call.argument<Int>("groupAddress")!!
                val group = meshNetwork.groups.first {
                    it.address == groupAddress
                }!!
                result.success(meshNetwork.removeGroup(group))
            }
            "getElementsForGroup" -> {
                val groupAddress = call.argument<Int>("groupAddress")!!
                val group = meshNetwork.groups.first {
                    it.address == groupAddress
                }!!
                result.success(meshNetwork.getElements(group).map { element ->
                    mapOf(
                            "name" to element.name,
                            "address" to element.elementAddress,
                            "locationDescriptor" to element.locationDescriptor,
                            "models" to element.meshModels.map {
                                mapOf(
                                        "key" to it.key,
                                        "modelId" to it.value.modelId,
                                        "subscribedAddresses" to it.value.subscribedAddresses,
                                        "boundAppKey" to it.value.boundAppKeyIndexes
                                )
                            }
                    )
                })
            }
            "nodes" -> {
                val provisionedMeshNodes = meshNetwork.nodes.map { node ->
                    DoozProvisionedMeshNode(binaryMessenger, node)
                }
                val nodes = provisionedMeshNodes.map { node ->
                    mapOf(
                            "uuid" to node.meshNode.uuid
                    )
                }
                result.success(nodes)
            }
            "getNode" -> {
                val address = call.argument<Int>("address")!!

                val provisionedMeshNode = meshNetwork.getNode(address)

                result.success(provisionedMeshNode.uuid)
            }
            "getProvisionersUUID" -> {
                val provisionersUUID = meshNetwork.provisioners.map { provisioner ->
                    provisioner.provisionerUuid
                }
                result.success(provisionersUUID)
            }
            "selectedProvisionerUuid" -> {
                result.success(meshNetwork.selectedProvisioner.provisionerUuid)
            }
            "getProvisionersAsJson" -> {

                val nodeList: List<Provisioner> = meshNetwork.provisioners
                val gsonBuilder = GsonBuilder()
                val provisionerListType: Type = object : TypeToken<List<Provisioner?>?>() {}.type
                gsonBuilder.registerTypeAdapter(provisionerListType, NodeDeserializer())
                val gson: Gson = gsonBuilder.create()
                val provisionerListJson: String = gson.toJson(nodeList)
                result.success(provisionerListJson)
            }
            "highestAllocatableAddress" -> {
                var maxAddress = 0
                for (addressRange in meshNetwork.selectedProvisioner.allocatedUnicastRanges) {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = addressRange.highAddress
                    }
                }
                result.success(maxAddress)
            }
            "addProvisioner" -> {
                val unicastAddressRange = call.argument<Int>("unicastAddressRange")!!
                val groupAddressRange = call.argument<Int>("groupAddressRange")!!
                val sceneAddressRange = call.argument<Int>("sceneAddressRange")!!
                val globalTtl = call.argument<Int>("globalTtl")!!

                try {
                    val unicastRange: AllocatedUnicastRange = meshNetwork.nextAvailableUnicastAddressRange(unicastAddressRange)
                    val groupRange: AllocatedGroupRange = meshNetwork.nextAvailableGroupAddressRange(groupAddressRange)
                    val sceneRange: AllocatedSceneRange = meshNetwork.nextAvailableSceneAddressRange(sceneAddressRange)!!
                    val provisioner: Provisioner = meshNetwork.createProvisioner("DOOZ Mesh Provisioner",
                            unicastRange, groupRange, sceneRange)
                    val unicastId = provisioner.allocatedUnicastRanges[0].lowAddress

                    provisioner.assignProvisionerAddress(unicastId)
                    provisioner.globalTtl = globalTtl

                    val success = this.addProvisioner(provisioner)
                    result.success(success)
                } catch (e: Exception) {
                    result.error("100", e.message, "Please check the given addresses range")
                }
            }
            "updateProvisioner" -> {
                val provisionerUuid = call.argument<String>("provisionerUuid")!!
                val provisionerName = call.argument<String>("provisionerName")!!
                val provisionerAddress = call.argument<Int>("provisionerAddress")!!
                val globalTtl = call.argument<Int>("globalTtl")!!
                val lastSelected = call.argument<Boolean>("lastSelected")!!

                meshNetwork.provisioners.forEach { provisioner ->
                    if (provisioner.provisionerUuid == provisionerUuid) {
                        provisioner.provisionerName = provisionerName
                        provisioner.provisionerAddress = provisionerAddress
                        provisioner.globalTtl = globalTtl
                        provisioner.isLastSelected = lastSelected
                        result.success(meshNetwork.updateProvisioner(provisioner))
                    }
                }
            }
            "deleteNode" -> {
                val uid = call.argument<String>("uid")!!
                var pNodeToDelete: ProvisionedMeshNode? = null
                meshNetwork.nodes.forEach { node ->
                    if (node.getUuid() == uid) {
                        pNodeToDelete = node
                    }
                }
                pNodeToDelete?.let { result.success(meshNetwork.deleteNode(it)) }
                result.success(false)
            }
            "getMeshModelSubscriptions" -> {
                val elementAddress = call.argument<Int>("elementAddress")!!
                val modelIdentifier = call.argument<Int>("modelIdentifier")!!

                val elements: Map<Int, Element> = meshNetwork.getNode(elementAddress).getElements()
                val addresses = elements[elementAddress]!!.meshModels[modelIdentifier]!!.subscribedAddresses
                val map = mapOf(
                        "elementId" to elementAddress,
                        "modelId" to modelIdentifier,
                        "addresses" to addresses,
                        "name" to "ModelSubscriptionAddresses"
                )
                result.success(map)
            }
            "getGroupElementIds" -> {
                val groupAddress = call.argument<Int>("groupAddress")!!
                val subscribedAddresses: HashMap<Any?, Any?> = HashMap<Any?, Any?>()

                val group: Group? = meshNetwork.getGroup(groupAddress)
                val elements: List<Element> = meshNetwork.getElements(group)

                for (element in elements) {
                    val models = element.meshModels
                    val onOff = models[GENERIC_ONOFF_SERVER]
                    val level = models[GENERIC_LEVEL_SERVER]
                    val onOffSubscribedAddresses = onOff!!.subscribedAddresses
                    val levelSubscribedAddresses = level!!.subscribedAddresses
                    val modelIds: MutableMap<Int, List<Int>> = HashMap()
                    modelIds[GENERIC_ONOFF_SERVER] = onOffSubscribedAddresses
                    modelIds[GENERIC_LEVEL_SERVER] = levelSubscribedAddresses
                    subscribedAddresses[element.elementAddress] = modelIds
                }
                result.success(subscribedAddresses)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
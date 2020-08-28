package fr.dooz.nordic_nrf_mesh

import android.annotation.SuppressLint
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshNetwork
import java.lang.IllegalArgumentException

class DoozMeshNetwork(private val binaryMessenger: BinaryMessenger, var meshNetwork: MeshNetwork) : EventChannel.StreamHandler, MethodChannel.MethodCallHandler {
    private var eventSink : EventChannel.EventSink? = null
    private var eventChannel: EventChannel = EventChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/events")
    private var methodChannel: MethodChannel = MethodChannel(binaryMessenger,"$namespace/mesh_network/${meshNetwork.id}/methods")

    init {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler(this)
    }

    private fun getId(): String? {
        return meshNetwork.id
    }

    private fun getMeshNetworkName() : String {
        return meshNetwork.meshName
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
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
            "getSequenceNumberForAddress" -> {
                val address = call.argument<Int>("address")!!
                result.success(meshNetwork.sequenceNumbers.get(address))
            }
            "createGroupWithName" -> {
                val groupName = call.argument<String>("name")!!
                val group = meshNetwork.createGroup(meshNetwork.selectedProvisioner, groupName)
                result.success(mapOf(
                        "id" to group.id,
                        "name" to group.name,
                        "address" to group.address,
                        "addressLabel" to group.addressLabel.toString(),
                        "meshUuid" to group.meshUuid,
                        "parentAddress" to group.parentAddress,
                        "parentAddressLabel" to group.parentAddressLabel.toString()
                ))
            }
            "addGroup" -> {
                val id = call.argument<Int>("id")!!
                val group = meshNetwork.groups.first {
                    it.id == id
                }!!
                result.success(meshNetwork.addGroup(group))
            }
            "groups" -> {
                result.success(meshNetwork.groups.map {
                            mapOf(
                                    "id" to it.id,
                                    "name" to it.name,
                                    "address" to it.address,
                                    "addressLabel" to it.addressLabel.toString(),
                                    "meshUuid" to it.meshUuid,
                                    "parentAddress" to it.parentAddress,
                                    "parentAddressLabel" to it.parentAddressLabel.toString()

                            )
                        }
                )
            }
            "deleteGroup" -> {
                val id = call.argument<Int>("id")!!
                val group = meshNetwork.groups.first {
                    it.id == id
                }!!
                result.success(meshNetwork.removeGroup(group))
            }
            "getElementsForGroup" -> {
                val id = call.argument<Int>("id")!!
                val group = meshNetwork.groups.first {
                    it.id == id
                }!!
                result.success(meshNetwork.getElements(group).map {element ->
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
            "selectedProvisionerUuid" -> {
                result.success(meshNetwork.selectedProvisioner.provisionerUuid)
            }
            "highestAllocatableAddress" -> {
                var maxAddress = 0;
                for (addressRange in meshNetwork.selectedProvisioner.allocatedUnicastRanges) {
                    if (maxAddress < addressRange.highAddress) {
                        maxAddress = addressRange.highAddress
                    }
                }
                result.success(maxAddress)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
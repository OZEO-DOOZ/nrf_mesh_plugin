package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.util.Log
import fr.dooz.nordic_nrf_mesh.ble.BleMeshManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.*
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode

class DoozMeshManagerApi(context: Context, binaryMessenger: BinaryMessenger) : StreamHandler, MethodChannel.MethodCallHandler {
    private  var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink :EventSink? = null
    private var doozMeshNetwork: DoozMeshNetwork? = null
    val doozMeshManagerCallbacks: DoozMeshManagerCallbacks;
    val doozMeshProvisioningStatusCallbacks: DoozMeshProvisioningStatusCallbacks;

    init {
        Log.d(this.javaClass.name, "init DoozMeshManagerApi")
        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)

        doozMeshManagerCallbacks = DoozMeshManagerCallbacks(binaryMessenger, eventSink)
        doozMeshProvisioningStatusCallbacks = DoozMeshProvisioningStatusCallbacks(eventSink)

        mMeshManagerApi.setMeshManagerCallbacks(doozMeshManagerCallbacks)
        mMeshManagerApi.setProvisioningStatusCallbacks(doozMeshProvisioningStatusCallbacks)
    }

    private fun loadMeshNetwork()  {
        mMeshManagerApi.loadMeshNetwork()
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
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        doozMeshManagerCallbacks.eventSink = null
        doozMeshProvisioningStatusCallbacks.eventSink = null
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
            "setMtuSize" -> {
                doozMeshManagerCallbacks.mtuSize = call.argument<Int>("mtuSize")!!
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}

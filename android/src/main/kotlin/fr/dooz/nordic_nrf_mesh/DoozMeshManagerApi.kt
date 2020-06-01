package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.*

class DoozMeshManagerApi(context: Context, private val binaryMessenger: BinaryMessenger) : StreamHandler, MethodChannel.MethodCallHandler {
    private  var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink :EventSink? = null
    private var doozMeshNetwork: DoozMeshNetwork? = null
    private val doozMeshManagerCallbacks: DoozMeshManagerCallbacks;

    init {
        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)

        doozMeshManagerCallbacks = DoozMeshManagerCallbacks(binaryMessenger, eventSink)

        mMeshManagerApi.setMeshManagerCallbacks(doozMeshManagerCallbacks)
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
        Log.d(this.javaClass.name, "onListen")
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        doozMeshManagerCallbacks.eventSink = null;
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
        }
    }
}

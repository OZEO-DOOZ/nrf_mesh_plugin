package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import no.nordicsemi.android.mesh.*
import no.nordicsemi.android.mesh.provisionerstates.ProvisioningState
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode
import no.nordicsemi.android.mesh.transport.ControlMessage
import no.nordicsemi.android.mesh.transport.MeshMessage
import no.nordicsemi.android.mesh.transport.ProvisionedMeshNode


public class DoozMeshManagerApi(context: Context, private val binaryMessenger: BinaryMessenger) : MeshManagerCallbacks, StreamHandler, MethodChannel.MethodCallHandler {
    private  var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink :EventSink? = null
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    private var doozMeshNetwork: DoozMeshNetwork? = null

    init {
        mMeshManagerApi.setMeshManagerCallbacks(this)
        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)
    }

    private fun loadMeshNetwork()  {
        mMeshManagerApi.loadMeshNetwork()
    }

    private fun importMeshNetworkJson(json: String?) {
        if (json == null) {
            return
        }
        mMeshManagerApi.importMeshNetworkJson(json);
    }

    override fun onNetworkImported(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkImported")
        if (meshNetwork == null) {
            return;
        }
        if (doozMeshNetwork == null) {
            doozMeshNetwork = DoozMeshNetwork(binaryMessenger, meshNetwork)
        } else {
            doozMeshNetwork?.meshNetwork = meshNetwork
        }
        eventSink?.success(mapOf(
                "eventName" to "onNetworkImported",
                "id" to meshNetwork.id,
                "meshName" to meshNetwork.meshName,
                "isLastSelected" to meshNetwork.isLastSelected
        ))
    }

    override fun onNetworkLoadFailed(error: String?) {
        Log.d(this.javaClass.name, "onNetworkLoadFailed")
        eventSink?.success(mapOf(
                "eventName" to "onNetworkLoadFailed",
                "error" to error
        ))
    }

    override fun onMeshPduCreated(pdu: ByteArray?) {
        Log.d(this.javaClass.name, "onMeshPduCreated")
    }

    override fun getMtu(): Int {
        Log.d(this.javaClass.name, "getMtu")
        return -1
    }

    override fun onNetworkImportFailed(error: String?) {
        Log.d(this.javaClass.name, "onNetworkImportFailed")
        eventSink?.success(mapOf(
                "eventName" to "onNetworkImportFailed",
                "error" to error
        ))
    }

    override fun onNetworkLoaded(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkLoaded")
        if (meshNetwork == null) {
            return;
        }
        if (doozMeshNetwork == null) {
            doozMeshNetwork = DoozMeshNetwork(binaryMessenger, meshNetwork)
        } else {
            doozMeshNetwork?.meshNetwork = meshNetwork
        }
        eventSink?.success(mapOf(
                "eventName" to "onNetworkLoaded",
                "id" to meshNetwork.id,
                "meshName" to meshNetwork.meshName,
                "isLastSelected" to meshNetwork.isLastSelected
        ))
    }

    override fun onNetworkUpdated(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkUpdated")
        if (meshNetwork == null) {
            return;
        }
        doozMeshNetwork?.meshNetwork = meshNetwork
        eventSink?.success(mapOf(
                "eventName" to "onNetworkUpdated",
                "id" to meshNetwork.id,
                "meshName" to meshNetwork.meshName,
                "isLastSelected" to meshNetwork.isLastSelected
        ))
    }

    override fun sendProvisioningPdu(meshNode: UnprovisionedMeshNode?, pdu: ByteArray?) {
        Log.d(this.javaClass.name, "sendProvisioningPdu")
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        Log.d(this.javaClass.name, "onListen")
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadMeshNetwork" -> {
                loadMeshNetwork()
                result.success(null)
            }
            "importMeshNetworkJson" -> {
                importMeshNetworkJson(call.argument<String>("json"));
                result.success(null);
            }
        }
    }
}

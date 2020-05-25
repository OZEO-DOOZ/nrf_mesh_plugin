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
import no.nordicsemi.android.mesh.MeshManagerApi
import no.nordicsemi.android.mesh.MeshManagerCallbacks
import no.nordicsemi.android.mesh.MeshNetwork
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode


public class DoozMeshManagerApi(context: Context, private var binaryMessenger: BinaryMessenger) : MeshManagerCallbacks, StreamHandler, MethodChannel.MethodCallHandler {
    private  var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
    private var eventSink :EventSink? = null
    private var onNetworkLoadedChannel: Channel<MeshNetwork?>;
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    init {
        mMeshManagerApi.setMeshManagerCallbacks(this)
        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)

        onNetworkLoadedChannel = Channel();
    }

    private  fun loadMeshNetwork(result: MethodChannel.Result)  {
        mMeshManagerApi.loadMeshNetwork()
        GlobalScope.launch {
            val meshNetwork = onNetworkLoadedChannel.receive()
            uiThreadHandler.post {
                result.success(mapOf(
                    "meshName" to meshNetwork?.meshName,
                    "id" to meshNetwork?.id,
                    "isLastSelected" to meshNetwork?.isLastSelected
                ))

            }
        }
    }

    override fun onNetworkImported(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkImported")
    }

    override fun onNetworkLoadFailed(error: String?) {
        Log.d(this.javaClass.name, "onNetworkLoadFailed")
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
    }

    override fun onNetworkLoaded(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkLoaded")
        eventSink?.success(mapOf(
                "eventName" to "onNetworkLoaded",
                "meshName" to meshNetwork?.meshName,
                "id" to meshNetwork?.id,
                "isLastSelected" to meshNetwork?.isLastSelected
        ))
        GlobalScope.launch {
            onNetworkLoadedChannel.send(meshNetwork)
        }
    }

    override fun onNetworkUpdated(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkUpdated")
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
                loadMeshNetwork(result)
            }
        }
    }
}

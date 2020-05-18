package fr.dooz.nordic_nrf_mesh

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel
import no.nordicsemi.android.mesh.MeshManagerApi
import no.nordicsemi.android.mesh.MeshManagerCallbacks
import no.nordicsemi.android.mesh.MeshNetwork
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode

public class DoozMeshManagerApi: MeshManagerCallbacks, StreamHandler {
    private  var mMeshManagerApi: MeshManagerApi
    private var methodChannel: MethodChannel
    private var eventSink :EventSink? = null

    constructor(context: Context, methodChannel: MethodChannel, binaryMessenger: BinaryMessenger) {
        mMeshManagerApi = MeshManagerApi(context.applicationContext)
        mMeshManagerApi.setMeshManagerCallbacks(this)
        this.methodChannel = methodChannel

        EventChannel(binaryMessenger,"$namespace/meshnetwork/events").setStreamHandler(this)
    }

    fun loadMeshNetwork() {
        mMeshManagerApi.loadMeshNetwork()
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
        Log.d(this.javaClass.name, "onNetworkLoaded ${meshNetwork?.meshName}")
        Log.d(this.javaClass.name, "onNetworkLoaded ${meshNetwork?.id}")
        Log.d(this.javaClass.name, "onNetworkLoaded eventSink $eventSink")

        eventSink?.success(mapOf("eventName" to "onNetworkLoaded", "meshName" to meshNetwork?.meshName))
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
    }
}

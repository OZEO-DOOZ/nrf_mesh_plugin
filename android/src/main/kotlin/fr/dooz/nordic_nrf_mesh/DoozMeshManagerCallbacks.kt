package fr.dooz.nordic_nrf_mesh

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import no.nordicsemi.android.mesh.MeshManagerCallbacks
import no.nordicsemi.android.mesh.MeshNetwork
import no.nordicsemi.android.mesh.provisionerstates.UnprovisionedMeshNode

class DoozMeshManagerCallbacks(private val binaryMessenger: BinaryMessenger, var eventSink : EventChannel.EventSink?) : MeshManagerCallbacks {
    private var doozMeshNetwork: DoozMeshNetwork? = null

    var mtuSize: Int = -1

    override fun onNetworkImported(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkImported")
        if (meshNetwork == null) {
            return
        }
        if (doozMeshNetwork == null || doozMeshNetwork?.meshNetwork?.id != meshNetwork.id) {
            doozMeshNetwork = DoozMeshNetwork(binaryMessenger, meshNetwork)
        } else {
            doozMeshNetwork?.meshNetwork = meshNetwork
        }
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onNetworkImported",
                    "id" to meshNetwork.id
            ))
        }
    }

    override fun onNetworkLoadFailed(error: String?) {
        Log.d(this.javaClass.name, "onNetworkLoadFailed")
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onNetworkLoadFailed",
                    "error" to error
            ))
        }
    }

    override fun onMeshPduCreated(pdu: ByteArray?) {
        Log.d(this.javaClass.name, "onMeshPduCreated")
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onMeshPduCreated",
                    "pdu" to pdu
            ))
        }
    }

    override fun getMtu(): Int {
        Log.d(this.javaClass.name, "getMtu $mtuSize")
        return mtuSize
    }

    override fun onNetworkImportFailed(error: String?) {
        Log.d(this.javaClass.name, "onNetworkImportFailed")
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onNetworkImportFailed",
                    "error" to error
            ))
        }
    }

    override fun onNetworkLoaded(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkLoaded")
        if (meshNetwork == null) {
            return
        }
        if (doozMeshNetwork == null || doozMeshNetwork?.meshNetwork?.id != meshNetwork.id) {
            doozMeshNetwork = DoozMeshNetwork(binaryMessenger, meshNetwork)
        } else {
            doozMeshNetwork!!.meshNetwork = meshNetwork
        }
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onNetworkLoaded",
                    "id" to meshNetwork.id
            ))
        }
    }

    override fun onNetworkUpdated(meshNetwork: MeshNetwork?) {
        Log.d(this.javaClass.name, "onNetworkUpdated")
        if (meshNetwork == null) {
            return
        }
        doozMeshNetwork?.meshNetwork = meshNetwork
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "onNetworkUpdated",
                    "id" to meshNetwork.id
            ))
        }
    }

    override fun sendProvisioningPdu(meshNode: UnprovisionedMeshNode?, pdu: ByteArray?) {
        Log.d(this.javaClass.name, "sendProvisioningPdu")
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                    "eventName" to "sendProvisioningPdu",
                    "pdu" to pdu,
                    "meshNode" to mapOf(
                            "uuid" to meshNode!!.deviceUuid!!.toString()
                    )
            ))
        }
    }
}
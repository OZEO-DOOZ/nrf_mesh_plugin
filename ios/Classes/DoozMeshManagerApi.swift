//
//  DoozMeshManagerApi.swift
//  nordic_nrf_mesh
//
//  Created by Alexis Barat on 29/05/2020.
//

import Foundation
import nRFMeshProvision

class DoozMeshManager{
    
    let meshNetworkManager: MeshNetworkManager?

    init() {
        meshNetworkManager = MeshNetworkManager()
        guard let _meshNetworkManager = self.meshNetworkManager else{
            return
        }
        _meshNetworkManager.acknowledgmentTimerInterval = 0.150
        _meshNetworkManager.transmissionTimerInteral = 0.600
        _meshNetworkManager.incompleteMessageTimeout = 10.0
        _meshNetworkManager.retransmissionLimit = 2
        _meshNetworkManager.acknowledgmentMessageInterval = 4.2
        // As the interval has been increased, the timeout can be adjusted.
        // The acknowledged message will be repeated after 4.2 seconds,
        // 12.6 seconds (4.2 + 4.2 * 2), and 29.4 seconds (4.2 + 4.2 * 2 + 4.2 * 4).
        // Then, leave 10 seconds for until the incomplete message times out.
        _meshNetworkManager.acknowledgmentMessageTimeout = 40.0

    }

    func loadMeshNetwork(_ result: FlutterResult){
        guard let _meshNetworkManager = self.meshNetworkManager else{
            print("meshNetworkManager has not been initialized")
            return
        }

        do{
            let loaded = try _meshNetworkManager.load()
        }catch{
            print(error)
        }

    }
    
}

//public class DoozMeshManagerApi(context: Context, binaryMessenger: BinaryMessenger) : MeshManagerCallbacks, StreamHandler, MethodChannel.MethodCallHandler {
//    private  var mMeshManagerApi: MeshManagerApi = MeshManagerApi(context.applicationContext)
//    private var eventSink :EventSink? = null
//    private var onNetworkLoadedChannel: Channel<MeshNetwork?>;
//    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
//
//    init {
//        mMeshManagerApi.setMeshManagerCallbacks(this)
//        EventChannel(binaryMessenger,"$namespace/mesh_manager_api/events").setStreamHandler(this)
//        MethodChannel(binaryMessenger, "$namespace/mesh_manager_api/methods").setMethodCallHandler(this)
//
//        onNetworkLoadedChannel = Channel();
//    }
//
//    private  fun loadMeshNetwork(result: MethodChannel.Result)  {
//        mMeshManagerApi.loadMeshNetwork()
//        GlobalScope.launch {
//            val meshNetwork = onNetworkLoadedChannel.receive()
//            uiThreadHandler.post {
//                result.success(mapOf(
//                    "meshName" to meshNetwork?.meshName,
//                    "id" to meshNetwork?.id,
//                    "isLastSelected" to meshNetwork?.isLastSelected
//                ))
//
//            }
//        }
//    }
//
//    override fun onNetworkImported(meshNetwork: MeshNetwork?) {
//        Log.d(this.javaClass.name, "onNetworkImported")
//    }
//
//    override fun onNetworkLoadFailed(error: String?) {
//        Log.d(this.javaClass.name, "onNetworkLoadFailed")
//    }
//
//    override fun onMeshPduCreated(pdu: ByteArray?) {
//        Log.d(this.javaClass.name, "onMeshPduCreated")
//    }
//
//    override fun getMtu(): Int {
//        Log.d(this.javaClass.name, "getMtu")
//        return -1
//    }
//
//    override fun onNetworkImportFailed(error: String?) {
//        Log.d(this.javaClass.name, "onNetworkImportFailed")
//    }
//
//    override fun onNetworkLoaded(meshNetwork: MeshNetwork?) {
//        Log.d(this.javaClass.name, "onNetworkLoaded")
//        eventSink?.success(mapOf(
//                "eventName" to "onNetworkLoaded",
//                "meshName" to meshNetwork?.meshName,
//                "id" to meshNetwork?.id,
//                "isLastSelected" to meshNetwork?.isLastSelected
//        ))
//        GlobalScope.launch {
//            onNetworkLoadedChannel.send(meshNetwork)
//        }
//    }
//
//    override fun onNetworkUpdated(meshNetwork: MeshNetwork?) {
//        Log.d(this.javaClass.name, "onNetworkUpdated")
//    }
//
//    override fun sendProvisioningPdu(meshNode: UnprovisionedMeshNode?, pdu: ByteArray?) {
//        Log.d(this.javaClass.name, "sendProvisioningPdu")
//    }
//
//    override fun onListen(arguments: Any?, events: EventSink?) {
//        Log.d(this.javaClass.name, "onListen")
//        this.eventSink = events
//    }
//
//    override fun onCancel(arguments: Any?) {
//        eventSink = null
//    }
//
//    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//        when (call.method) {
//            "loadMeshNetwork" -> {
//                loadMeshNetwork(result)
//            }
//        }
//    }
//}

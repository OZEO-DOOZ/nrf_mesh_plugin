import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/scan_and_provisionning/device.dart';
import 'package:pedantic/pedantic.dart';

class ScanningAndProvisioning extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const ScanningAndProvisioning({Key key, @required this.nordicNrfMesh}) : super(key: key);

  @override
  _ScanningAndProvisioningState createState() => _ScanningAndProvisioningState();
}

class _ScanningAndProvisioningState extends State<ScanningAndProvisioning> {
  final flutterBlue = FlutterBlue.instance;
  BleMeshManager bleMeshManager = BleMeshManager();

  bool loading = true;
  bool isScanning = true;
  StreamSubscription _scanSubscription;
  BluetoothDevice _connectedDevice;
  MeshNetwork _meshNetwork;
  MeshManagerApi _meshManagerApi;

  Map<String, Guid> _serviceData = {};
  Set<BluetoothDevice> _devices = {};

  @override
  void initState() {
    super.initState();
    _scanUnprovisionned();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    if (_connectedDevice != null) {
      bleMeshManager.disconnect();
    }
    bleMeshManager?.callbacks?.dispose();
    flutterBlue.stopScan();
    _scanSubscription?.cancel();
  }

  Future<void> _init() async {
    _meshManagerApi = await widget.nordicNrfMesh.meshManagerApi;
    _meshManagerApi.onProvisioningCompleted.listen((event) {
      print('onProvisioningCompleted ${event.meshNodeUuid} ${event.data} ${event.state}');
    });
    _meshManagerApi.onProvisioningStateChanged.listen((event) {
      print('onProvisioningStateChanged ${event.meshNodeUuid} ${event.data} ${event.state}');
    });
    _meshManagerApi.onProvisioningFailed.listen((event) {
      print('onProvisioningFailed ${event.meshNodeUuid} ${event.data} ${event.state}');
    });
    _meshManagerApi.sendProvisioningPdu.listen((event) {
      print('sendProvisioningPdu $event');
      bleMeshManager.sendPdu(event.pdu);
    });
    _meshManagerApi.onMeshPduCreated.listen((event) {
      print('onMeshPduCreated $event');
      bleMeshManager.sendPdu(event);
    });
    _meshNetwork = await _meshManagerApi.loadMeshNetwork();
    setState(() {
      loading = false;
    });
  }

  Future<void> _scanUnprovisionned() {
    _serviceData.clear();
    _scanSubscription = flutterBlue.scan(
      withServices: [
        meshProxyUuid,
        meshProvisioningUuid,
      ],
    ).listen((scanResult) async {
      _serviceData[scanResult.device.id.id] = Guid(await _meshManagerApi
          .getDeviceUuid(scanResult.advertisementData.serviceData[meshProvisioningUuid.toString()]));
      setState(() {
        _devices.add(scanResult.device);
      });
    });
    setState(() {
      isScanning = true;
    });

    return Future.delayed(Duration(seconds: 20)).then((_) => _stopScan());
  }

  Future<void> _stopScan() async {
    if (!mounted) {
      return;
    }
    await flutterBlue.stopScan();
    await _scanSubscription?.cancel();
    setState(() {
      isScanning = false;
    });
  }

  Future<void> provisionDevice(BluetoothDevice device) async {
    if (isScanning) {
      await _stopScan();
    }
    if (_connectedDevice != null) {
      await bleMeshManager.disconnect();
    }
    await bleMeshManager.callbacks?.dispose();
    bleMeshManager.callbacks = DoozBleMeshManagerCallbacks(_meshManagerApi);
    bleMeshManager.callbacks.onDeviceConnecting.listen(print);
    bleMeshManager.callbacks.onDeviceConnected.listen(print);

    bleMeshManager.callbacks.onServicesDiscovered.listen((event) {
      print('onServicesDiscovered');
    });

    bleMeshManager.callbacks.onDeviceReady.listen((event) {
      print('onDeviceReady $event');
      _meshManagerApi.identifyNode(_serviceData[event.id.id].toString());
    });

    bleMeshManager.callbacks.onDataReceived.listen((event) async {
      print('onDataReceived ${event.device.id.id} ${event.mtu} ${event.pdu}');
      final meshManagerApi = await widget.nordicNrfMesh.meshManagerApi;
      await meshManagerApi.handleNotifications(event.mtu, event.pdu);
    });
    bleMeshManager.callbacks.onDataSent.listen((event) async {
      print('onDataSent ${event.device.id.id} ${event.mtu} ${event.pdu}');
      final meshManagerApi = await widget.nordicNrfMesh.meshManagerApi;
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });

    bleMeshManager.callbacks.onDeviceDisconnected.listen(print);
    bleMeshManager.callbacks.onDeviceDisconnecting.listen(print);

    await flutterBlue.state.listen(print);

    print('connect');
    await bleMeshManager.connect(device);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () {
        if (isScanning) {
          return Future.value();
        }
        return _scanUnprovisionned();
      },
      child: Column(
        children: [
          if (isScanning) LinearProgressIndicator(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                for (final device in _devices)
                  Device(
                    device: device,
                    onTap: () => provisionDevice(device),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoozBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi _meshManagerApi;

  DoozBleMeshManagerCallbacks(this._meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) async => _meshManagerApi.setMtu(mtu);
}

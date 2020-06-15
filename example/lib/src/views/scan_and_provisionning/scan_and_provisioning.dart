import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/scan_and_provisionning/device.dart';

class ScanningAndProvisioning extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const ScanningAndProvisioning({Key key, @required this.nordicNrfMesh}) : super(key: key);

  @override
  _ScanningAndProvisioningState createState() => _ScanningAndProvisioningState();
}

class _ScanningAndProvisioningState extends State<ScanningAndProvisioning> {
  final flutterBlue = FlutterBlue.instance;

  bool loading = true;
  bool isScanning = true;
  StreamSubscription _scanSubscription;
  MeshManagerApi _meshManagerApi;

  final _serviceData = <String, Guid>{};
  final _devices = <BluetoothDevice>{};

  @override
  void initState() {
    super.initState();

    flutterBlue.state.listen((event) => print('bluetooth state changed to $event'));

    _scanUnprovisionned();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
    _scanSubscription?.cancel();
  }

  Future<void> _init() async {
    _meshManagerApi = await widget.nordicNrfMesh.meshManagerApi;

    await _meshManagerApi.loadMeshNetwork();

    setState(() {
      loading = false;
    });
  }

  Future<void> _scanUnprovisionned() {
    _serviceData.clear();
    _devices.clear();

    _scanSubscription = flutterBlue.scan(
      withServices: [
        meshProvisioningUuid,
      ],
    ).listen((scanResult) async {
      _serviceData[scanResult.device.id.id] = Guid(_meshManagerApi
          .getDeviceUuid(scanResult.advertisementData.serviceData[_meshManagerApi.meshProvisioningUuidServiceKey]));
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

    if (Platform.isIOS) {
      await _meshManagerApi.provisioning(_serviceData[device.id.id].toString());
      return;
    }
    try {
      await provisioning(_meshManagerApi, device, _serviceData[device.id.id].toString());
    } catch (e) {
      print(e);
    }
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

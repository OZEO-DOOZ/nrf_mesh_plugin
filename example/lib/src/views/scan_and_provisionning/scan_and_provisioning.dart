import 'dart:async';

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

  bool isScanning = true;
  StreamSubscription _scanSubscription;
  BluetoothDevice _connectedDevice;

  Set<BluetoothDevice> _devices = {};

  @override
  void initState() {
    super.initState();
    _scanUnprovisionned();
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
    _scanSubscription?.cancel();
  }

  Future<void> _scanUnprovisionned() {
    flutterBlue.state.first;
    _scanSubscription = flutterBlue.scan(
      withServices: [
        Guid('00001828-0000-1000-8000-00805F9B34FB'),
        Guid('00001827-0000-1000-8000-00805F9B34FB'),
      ],
    ).listen((scanResult) {
      print(scanResult.device.id.id);
      print(scanResult.rssi);
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
    if (_connectedDevice != null) {
      await _connectedDevice.disconnect();
    }
    print('connect to device ${device.id.id}');
    await device.connect();
    _connectedDevice = device;
    final services = await device.discoverServices();
    for (final service in services) {
      print('${service.uuid} ${service.deviceId}');
      for (final characteristic in service.characteristics) {
        print('${characteristic.uuid} ${characteristic.deviceId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

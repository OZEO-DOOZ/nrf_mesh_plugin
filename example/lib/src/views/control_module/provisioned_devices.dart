import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/module.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/device.dart';

class ProvisionedDevices extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const ProvisionedDevices({Key key, this.nordicNrfMesh}) : super(key: key);

  @override
  _ProvisionedDevicesState createState() => _ProvisionedDevicesState();
}

class _ProvisionedDevicesState extends State<ProvisionedDevices> {
  final flutterBlue = FlutterBlue.instance;
  final _devices = <BluetoothDevice>{};

  MeshManagerApi _meshManagerApi;
  bool loading = true;
  bool isScanning = false;
  StreamSubscription<ScanResult> _scanSubscription;
  final _serviceData = <String, Guid>{};

  @override
  void initState() {
    super.initState();

    _init();
    _scanProvisionned();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isScanning) LinearProgressIndicator(),
        if (!isScanning && _devices.isEmpty)
          Expanded(
            child: Center(
              child: Text('No module found'),
            ),
          ),
        if (_devices.isNotEmpty)
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                for (final device in _devices)
                  Device(
                    device: device,
                    onTap: () {
                      _stopScan();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return Module(device: device, meshManagerApi: _meshManagerApi);
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _init() async {
    _meshManagerApi = await widget.nordicNrfMesh.meshManagerApi;

    await _meshManagerApi.loadMeshNetwork();

    setState(() {
      loading = false;
    });
  }

  Future<void> _scanProvisionned() {
    setState(() {
      _devices.clear();
    });

    //  TODO: we should check if the device advertise with the good network id
    _scanSubscription = flutterBlue.scan(
      withServices: [
        meshProxyUuid,
      ],
    ).listen((scanResult) async {
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
}

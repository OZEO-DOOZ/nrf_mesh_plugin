import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/device.dart';
import 'package:pedantic/pedantic.dart';

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
  bool isProvisioning = false;
  StreamSubscription _scanSubscription;
  MeshManagerApi _meshManagerApi;

  final _serviceData = <String, Guid>{};
  final _devices = <BluetoothDevice>{};

  @override
  void initState() {
    super.initState();

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

  Future<void> isNotScanning(FlutterBlue flutterBlue) {
    final completer = Completer<void>();

    flutterBlue.isScanning.listen((event) {
      if (!event && !completer.isCompleted) {
        completer.complete(null);
      }
    });

    flutterBlue.stopScan();

    return completer.future;
  }

  Future<void> _scanUnprovisionned() async {
    _serviceData.clear();
    setState(() {
      _devices.clear();
    });

    await isNotScanning(flutterBlue);

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
    if (isProvisioning) {
      return;
    }
    isProvisioning = true;

    final scaffoldState = Scaffold.of(context);

    try {
      // Android is sending the mac Adress of the device, but Apple generates
      // an UUID specific by smartphone.

      String deviceUUID;

      if (Platform.isAndroid) {
        deviceUUID = _serviceData[device.id.id].toString();
      } else if (Platform.isIOS) {
        deviceUUID = device.id.id.toString();
      }
      final provisioningEvent = ProvisioningEvent();
      final provisionedMeshNodeF = widget.nordicNrfMesh
          .provisioning(
            _meshManagerApi,
            BleMeshManager(),
            device,
            deviceUUID,
            events: provisioningEvent,
          )
          .timeout(Duration(minutes: 1));

      unawaited(provisionedMeshNodeF.then((node) async {
        Navigator.of(context).pop();
        scaffoldState.showSnackBar(SnackBar(content: Text('Provisionning succeed')));
      }).catchError((_) {
        Navigator.of(context).pop();
        scaffoldState.showSnackBar(SnackBar(content: Text('Provisionning failed')));
      }));
      await showDialog(
        context: context,
        barrierDismissible: false,
        child: ProvisioningDialog(
          provisioningEvent: provisioningEvent,
        ),
      );
      unawaited(_scanUnprovisionned());
    } catch (e) {
      print(e);
      scaffoldState.showSnackBar(SnackBar(content: Text('Caught error: $e')));
    } finally {
      isProvisioning = false;
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
                  for (var i = 0; i < _devices.length; i++)
                    Device(
                      key: ValueKey('device-$i'),
                      device: _devices.elementAt(i),
                      onTap: () => provisionDevice(_devices.elementAt(i)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ProvisioningDialog extends StatelessWidget {
  final ProvisioningEvent provisioningEvent;

  const ProvisioningDialog({Key key, @required this.provisioningEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text('Steps :'),
                  Column(
                    children: [
                      ProvisioningState(
                        text: 'onProvisioningCapabilities',
                        stream: provisioningEvent.onProvisioningCapabilities.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onProvisioning',
                        stream: provisioningEvent.onProvisioning.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onProvisioningReconnect',
                        stream: provisioningEvent.onProvisioningReconnect.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onConfigCompositionDataStatus',
                        stream: provisioningEvent.onConfigCompositionDataStatus.map((event) => true),
                      ),
                      ProvisioningState(
                        text: 'onConfigAppKeyStatus',
                        stream: provisioningEvent.onConfigAppKeyStatus.map((event) => true),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProvisioningState extends StatelessWidget {
  final Stream<bool> stream;
  final String text;

  const ProvisioningState({Key key, @required this.stream, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: stream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Text(text),
            Spacer(),
            Checkbox(
              value: snapshot.data,
              onChanged: null,
            ),
          ],
        );
      },
    );
  }
}

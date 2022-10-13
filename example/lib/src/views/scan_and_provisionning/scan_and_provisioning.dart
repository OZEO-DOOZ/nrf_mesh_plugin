import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/device.dart';

class ScanningAndProvisioning extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;
  final VoidCallback onGoToControl;

  const ScanningAndProvisioning({
    Key? key,
    required this.nordicNrfMesh,
    required this.onGoToControl,
  }) : super(key: key);

  @override
  State<ScanningAndProvisioning> createState() => _ScanningAndProvisioningState();
}

class _ScanningAndProvisioningState extends State<ScanningAndProvisioning> {
  late MeshManagerApi _meshManagerApi;
  bool isScanning = true;
  StreamSubscription? _scanSubscription;
  bool isProvisioning = false;

  final _serviceData = <String, Uuid>{};
  final _devices = <DiscoveredDevice>{};

  @override
  void initState() {
    super.initState();
    _meshManagerApi = widget.nordicNrfMesh.meshManagerApi;
    _scanUnprovisionned();
  }

  @override
  void dispose() {
    super.dispose();
    _scanSubscription?.cancel();
  }

  Future<void> _scanUnprovisionned() async {
    _serviceData.clear();
    setState(() {
      _devices.clear();
    });
    _scanSubscription = widget.nordicNrfMesh.scanForUnprovisionedNodes().listen((device) async {
      if (_devices.every((d) => d.id != device.id)) {
        final deviceUuid =
            Uuid.parse(_meshManagerApi.getDeviceUuid(device.serviceData[meshProvisioningUuid]!.toList()));
        debugPrint('deviceUuid: $deviceUuid');
        _serviceData[device.id] = deviceUuid;
        _devices.add(device);
        setState(() {});
      }
    });
    setState(() {
      isScanning = true;
    });
    return Future.delayed(const Duration(seconds: 10)).then((_) => _stopScan());
  }

  Future<void> _stopScan() async {
    await _scanSubscription?.cancel();
    isScanning = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> provisionDevice(DiscoveredDevice device) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (isScanning) {
      await _stopScan();
    }
    if (isProvisioning) {
      return;
    }
    isProvisioning = true;

    try {
      // Android is sending the mac Adress of the device, but Apple generates
      // an UUID specific by smartphone.

      String deviceUUID;

      if (Platform.isAndroid) {
        deviceUUID = _serviceData[device.id].toString();
      } else if (Platform.isIOS) {
        deviceUUID = device.id.toString();
      } else {
        throw UnimplementedError('device uuid on platform : ${Platform.operatingSystem}');
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
          .timeout(const Duration(minutes: 1));

      unawaited(provisionedMeshNodeF.then((node) {
        Navigator.of(context).pop();
        scaffoldMessenger
            .showSnackBar(const SnackBar(content: Text('Provisionning succeed, redirecting to control tab...')));
        Future.delayed(const Duration(milliseconds: 500), widget.onGoToControl);
      }).catchError((_) {
        Navigator.of(context).pop();
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Provisionning failed')));
        _scanUnprovisionned();
      }));
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ProvisioningDialog(provisioningEvent: provisioningEvent),
      );
    } catch (e) {
      debugPrint('$e');
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('Caught error: $e')));
    } finally {
      isProvisioning = false;
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
          if (isScanning) const LinearProgressIndicator(),
          if (!isScanning && _devices.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No module found'),
              ),
            ),
          if (_devices.isNotEmpty)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
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

  const ProvisioningDialog({Key? key, required this.provisioningEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text('Steps :'),
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

  const ProvisioningState({Key? key, required this.stream, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: stream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Text(text),
            const Spacer(),
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

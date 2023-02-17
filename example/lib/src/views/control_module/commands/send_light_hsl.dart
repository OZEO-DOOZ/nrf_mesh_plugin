import 'dart:async';

import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendLightHsl extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendLightHsl({
    Key? key,
    required this.meshManagerApi,
  }) : super(key: key);

  @override
  State<SendLightHsl> createState() => _SendLightHslState();
}

class _SendLightHslState extends State<SendLightHsl> {
  int? selectedLightness = 0;
  int? selectedHue = 0;
  int? selectedSaturation = 0;
  int? selectedElementAddress;

  ///
  double valueLightness = 0;
  double valueHue = 0;
  double valueSaturation = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-light-hsl-form'),
      title: const Text('Send a HSL set'),
      children: [
        TextField(
          key: const ValueKey('module-send-generic-on-off-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.tryParse(text);
            });
          },
        ),
        Row(
          children: [
            Text('Lightness: ${valueLightness.round()}'),
            Slider(
              value: valueLightness,
              onChanged: (value) {
                setState(() {
                  valueLightness = value;
                  selectedLightness = int.tryParse(value.round().toString());
                });
              },
              max: 65535,
              min: 0,
            ),
          ],
        ),
        Row(
          children: [
            Text('Hue: ${valueHue.round()}'),
            Slider(
              value: valueHue,
              onChanged: (value) {
                setState(() {
                  valueHue = value;
                  selectedHue = int.tryParse(value.round().toString());
                });
              },
              max: 65535,
              min: 0,
            ),
          ],
        ),
        Row(
          children: [
            Text('Saturation: ${valueSaturation.round()}'),
            Slider(
              value: valueSaturation,
              onChanged: (value) {
                setState(() {
                  valueSaturation = value;
                  selectedSaturation = int.tryParse(value.round().toString());
                });
              },
              max: 65535,
              min: 0,
            ),
          ],
        ),
        TextButton(
          onPressed: selectedElementAddress != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  debugPrint(
                      'send  $selectedHue, $selectedLightness and $selectedSaturation to $selectedElementAddress');
                  final provisionerUuid = await widget.meshManagerApi.meshNetwork!.selectedProvisionerUuid();
                  final nodes = await widget.meshManagerApi.meshNetwork!.nodes;
                  try {
                    final provisionedNode = nodes.firstWhere((element) => element.uuid == provisionerUuid);
                    final sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisionedNode);
                    await widget.meshManagerApi
                        .sendLightHsl(
                          selectedElementAddress!,
                          selectedLightness!,
                          selectedHue!,
                          selectedSaturation!,
                          sequenceNumber,
                        )
                        .timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on StateError catch (_) {
                    scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('No provisioner found with this uuid : $provisionerUuid')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send hsl'),
        )
      ],
    );
  }
}

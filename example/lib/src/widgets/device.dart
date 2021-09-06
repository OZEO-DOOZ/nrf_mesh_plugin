import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Device extends StatelessWidget {
  final DiscoveredDevice device;
  final VoidCallback? onTap;

  const Device({Key? key, required this.device, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('${device.name} : ${device.id}'),
        ),
      ),
    );
  }
}

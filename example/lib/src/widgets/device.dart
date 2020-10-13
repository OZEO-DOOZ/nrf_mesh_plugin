import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Device extends StatelessWidget {
  final BluetoothDevice device;
  final VoidCallback onTap;

  const Device({Key key, this.device, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(device.name),
        ),
      ),
    );
  }
}

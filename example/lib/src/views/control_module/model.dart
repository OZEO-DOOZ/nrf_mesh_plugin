import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Model extends StatelessWidget {
  final ModelData model;

  const Model(this.model) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[Text(' ${model.modelId} '), appKeyBindIcon(), Text(', ')],
    );
  }

  bool isAppKeyBound() {
    return model.boundAppKey.isNotEmpty;
  }

  Icon appKeyBindIcon() {
    return isAppKeyBound()
        ? Icon(
            Icons.check,
            size: 15,
            color: Colors.green,
          )
        : Icon(
            Icons.clear,
            size: 15,
            color: Colors.red,
          );
  }
}

import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Model extends StatelessWidget {
  final ModelData model;

  const Model(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text("ModelName:${getSigMeshName("0x${model.modelId.toRadixString(16).padLeft(4, '0').toUpperCase()}")}"),
            appKeyBindIcon(),
          ],
        ),
        Text("SigMesh(Dec): " '${model.modelId}'),
        Text("SigMesh(Hex): " '0x${model.modelId.toRadixString(16).padLeft(4, '0').toUpperCase()}'),
        const SizedBox(height: 15),
      ],
    );
  }

  bool isAppKeyBound() {
    return model.boundAppKey.isNotEmpty;
  }

  Icon appKeyBindIcon() {
    return isAppKeyBound()
        ? const Icon(
            Icons.check,
            size: 15,
            color: Colors.green,
          )
        : const Icon(
            Icons.clear,
            size: 15,
            color: Colors.red,
          );
  }
}

String getSigMeshName(String modelId) {
  switch (modelId) {

    /// Custom Models
    case "0x0000":
      return "Configuration Server";
    case "0x0002":
      return "Health Server";
    case "0x-7FFEFFFF":
      return "Vendor Model";

    /// Generic Models
    case "0x1000":
      return "Generic OnOff Server";
    case "0x1001":
      return "Generic OnOff Client";
    case "0x1002":
      return "Generic Level Server";
    case "0x1003":
      return "Generic Level Client";
    case "0x1004":
      return "Generic Default Transition Time Server";
    case "0x1005":
      return "Generic Default Transition Time Client";
    case "0x1006":
      return "Generic Power OnOff Server";
    case "0x1007":
      return "Generic Power OnOff Setup Server";
    case "0x1008":
      return "Generic Power OnOff Client";
    case "0x1009":
      return "Generic Power Level Server";
    case "0x100A":
      return "Generic Power Level Setup Server";
    case "0x100B":
      return "Generic Power Level Client";
    case "0x100C":
      return "Generic Battery Server";
    case "0x100D":
      return "Generic Battery Client";
    case "0x100E":
      return "Generic Location Server";
    case "0x100F":
      return "Generic Location Setup Server";
    case "0x1010":
      return "Generic Location Client";
    case "0x1011":
      return "Generic Admin Property Server";
    case "0x1012":
      return "Generic Manufacturer Property Server";
    case "0x1013":
      return "Generic User Property Server";
    case "0x1014":
      return "Generic Client Property Server";
    case "0x1015":
      return "Generic Property Client";

    /// Lighting Models
    case "0x1300":
      return "Light Lightness Server ";
    case "0x1301":
      return "Light Lightness Setup Server ";
    case "0x1302":
      return "Light Lightness Client ";
    case "0x1303":
      return "Light CTL Server ";
    case "0x1304":
      return "Light CTL Setup Server ";
    case "0x1305":
      return "Light CTL Client ";
    case "0x1306":
      return "Light CTL Temperature Server ";
    case "0x1307":
      return "Light HSL Server ";
    case "0x1308":
      return "Light HSL Setup Server ";
    case "0x1309":
      return "Light HSL Client";
    case "0x130A":
      return "Light HSL Hue Server";
    case "0x130B":
      return "Light HSL Saturation Server";
    case "0x130C":
      return "Light xyL Server";
    case "0x130D":
      return "Light xyL Setup Server";
    case "0x130E":
      return "Light xyL Client";
    case "0x130F":
      return "Light LC Server";
    case "0x1310":
      return "Light LC Setup Server";
    case "0x1311":
      return "Light LC Client ";

    /// Sensor Models
    case "0x1100":
      return "Sensor Server";
    case "0x1101":
      return "Sensor Setup Server";
    case "0x1102":
      return "Sensor Client";

    /// Time and scene Models
    case "0x1200":
      return "Time Server";
    case "0x1201":
      return "Time Setup Server";
    case "0x1202":
      return "Time Client";
    case "0x1203":
      return "Scene Server";
    case "0x1204":
      return "Scene Setup Server";
    case "0x1205":
      return "Scene Client";
    case "0x1206":
      return "Scheduler Server";
    case "0x1207":
      return "Scheduler Setup Server";
    default:
      return "Undefined Model";
  }
}

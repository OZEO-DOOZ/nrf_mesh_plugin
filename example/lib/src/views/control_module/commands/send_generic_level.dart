import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericLevel extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericLevel(this.meshManagerApi) : super();

  @override
  _SendGenericLevelState createState() => _SendGenericLevelState();
}

class _SendGenericLevelState extends State<SendGenericLevel> {
  int selectedElementAddress;

  int selectedLevel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a generic level set'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Level Value'),
          onChanged: (text) {
            selectedLevel = int.parse(text);
          },
        ),
        RaisedButton(
          child: Text('Send level'),
          onPressed: () async {
            print('send level $selectedLevel to $selectedElementAddress');
            final provisionerUuid = await widget.meshManagerApi.meshNetwork
                .selectedProvisionerUuid();
            final nodes = await widget.meshManagerApi.meshNetwork.nodes;

            final provisionedNode = nodes.firstWhere(
                (element) => element.uuid == provisionerUuid,
                orElse: () => null);
            final provisionerAddress = await provisionedNode.unicastAddress;
            // final sequenceNumber = await provisionedNode.sequenceNumber;
            final sequenceNumber = await widget.meshManagerApi.meshNetwork
                .getSequenceNumber(provisionerAddress);
            final status = await widget.meshManagerApi.sendGenericLevelSet(
                selectedElementAddress, selectedLevel, sequenceNumber);
            print(status);
          },
        )
      ],
    );
  }
}

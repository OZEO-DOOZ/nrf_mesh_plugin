import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericOnOff extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericOnOff({Key key, this.meshManagerApi}) : super(key: key);

  @override
  _SendGenericOnOffState createState() => _SendGenericOnOffState();
}

class _SendGenericOnOffState extends State<SendGenericOnOff> {
  int selectedElementAddress;

  bool onOff = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey('module-send-generic-on-off-form'),
      title: Text('Send a generic On Off set'),
      children: <Widget>[
        TextField(
          key: ValueKey('module-send-generic-on-off-address'),
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        Checkbox(
          key: ValueKey('module-send-generic-on-off-value'),
          value: false,
          onChanged: (value) {
            onOff = value;
          },
        ),
        RaisedButton(
          child: Text('Send on off'),
          onPressed: () async {
            print('send level $onOff to $selectedElementAddress');
            final provisionerUuid = await widget.meshManagerApi.meshNetwork.selectedProvisionerUuid();
            final nodes = await widget.meshManagerApi.meshNetwork.nodes;

            final provisionedNode = nodes.firstWhere((element) => element.uuid == provisionerUuid, orElse: () => null);
            final sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisionedNode);
            final status =
                await widget.meshManagerApi.sendGenericOnOffSet(selectedElementAddress, onOff, sequenceNumber);
            print(status);
          },
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/data/board_data.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/mesh_element.dart';

class Node extends StatefulWidget {
  final String name;
  final ProvisionedMeshNode node;
  final MeshManagerApi meshManagerApi;

  const Node({Key key, this.node, this.meshManagerApi, this.name}) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  bool isLoading = true;
  int nodeAddress;
  List<ElementData> elements;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    nodeAddress = await widget.node.unicastAddress;
    elements = await widget.node.elements;

    //
    //  ALL THE CODE UNDER THIS COMMENT IS SPECIFIC FOR DOOZ
    //
    final target = 0;
    //  check if the board need to be configured
    final provisioner = (await widget.meshManagerApi.meshNetwork.nodes).first;

    var sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisioner);

    final getBoardTypeStatus = await widget.meshManagerApi.sendGenericLevelSet(
        await widget.node.unicastAddress, BoardData.configuration(target).toByte(), sequenceNumber);
    print('getBoardTypeStatus $getBoardTypeStatus');
    final boardType = BoardData.decode(getBoardTypeStatus.level);
    if (boardType.payload == 0xA) {
      print('it\'s a Doobl V board');
      print('setup sortie ${target + 1} to be a dimmer');
      sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisioner);
      final setupDimmerStatus = await widget.meshManagerApi.sendGenericLevelSet(
          await widget.node.unicastAddress, BoardData.lightDimmerOutput(target).toByte(), sequenceNumber);
      final dimmerBoardData = BoardData.decode(setupDimmerStatus.level);
      print(dimmerBoardData);
    }
    //
    //  END OF SPECIFIC CODE FOR DOOZ
    //

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text('Configuring...'),
        ],
      ),
    );
    if (!isLoading) {
      body = ListView(
        children: [
          Text('Node ${nodeAddress}'),
          Text('${widget.node.uuid}'),
          ...[
            Text('Elements :'),
            Column(
              children: <Widget>[
                ...elements.map((element) => MeshElement(element)).toList(),
              ],
            ),
          ],
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: body,
    );
  }
}

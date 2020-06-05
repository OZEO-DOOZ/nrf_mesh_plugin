import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nordic_nrf_mesh_example/store/mesh_store.dart';

class MeshManagerApiWidget extends StatefulWidget {
  const MeshManagerApiWidget(this.meshStore, {Key key}) : super(key: key);

  final MeshStore meshStore;
  @override
  _MeshManagerApiWidget createState() => _MeshManagerApiWidget();
}

class _MeshManagerApiWidget extends State<MeshManagerApiWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> meshManagerApiButtons;
    if (widget.meshStore.meshManagerApi == null) {
      meshManagerApiButtons = [
        RaisedButton(
          child: Text('Create MeshManagerApi'),
          onPressed: () {
            widget.meshStore.createMeshManagerApi();
          },
        )
      ];
    } else {
      meshManagerApiButtons = [
        RaisedButton(
          child: Text('import MeshNetwork Json'),
          onPressed: () async {
            final filePath = await FilePicker.getFilePath(type: FileType.any);
            if (filePath == null) return;
            final file = await File(filePath);
            if (file == null) return;
            final json = await file.readAsString();
            if (json == null) return;
            await widget.meshStore.meshManagerApi.importMeshNetworkJson(json);
          },
        ),
        RaisedButton(
          child: Text('Load MeshNetwork'),
          onPressed: () {
            widget.meshStore.meshManagerApi.loadMeshNetwork();
          },
        )
      ];
    }
    return ExpansionTile(
      title: Text(widget.meshStore.meshManagerApi == null
          ? 'Mesh Manager not created'
          : 'Mesh Manager'),
      children: meshManagerApiButtons,
    );
  }
}

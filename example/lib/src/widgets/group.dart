import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/src/models/group/group.dart';

class Group extends StatelessWidget {
  final GroupData groupData;
  const Group(this.groupData) : super();

  @override
  Widget build(BuildContext context) {
    return Text('group');
  }
}

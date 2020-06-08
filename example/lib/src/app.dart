import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/home/home.dart';
import 'package:nordic_nrf_mesh_example/src/views/scan_and_provisionning/scan_and_provisioning.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nordicNrfMesh = NordicNrfMesh();

  int _bottomNavigationBarIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_bottomNavigationBarIndex == 0) {
      //  home
      body = Home(
        nordicNrfMesh: nordicNrfMesh,
      );
    } else if (_bottomNavigationBarIndex == 1) {
      //  scanning & provisionning
      body = ScanningAndProvisioning(
        nordicNrfMesh: nordicNrfMesh,
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavigationBarIndex,
          onTap: (newBottomNavigationBarIndex) {
            setState(() {
              _bottomNavigationBarIndex = newBottomNavigationBarIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bluetooth_searching),
              title: Text('Provisioning'),
            ),
          ],
        ),
      ),
    );
  }
}

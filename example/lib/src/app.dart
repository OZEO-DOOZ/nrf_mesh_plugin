import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/provisioned_devices.dart';
import 'package:nordic_nrf_mesh_example/src/views/home/home.dart';
import 'package:nordic_nrf_mesh_example/src/views/scan_and_provisionning/scan_and_provisioning.dart';

const int homeTab = 0;
const int provisioningTab = 1;
const int controlTab = 2;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'main_scaffold');
  final nordicNrfMesh = NordicNrfMesh();

  int _bottomNavigationBarIndex = homeTab;

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox.shrink();

    if (_bottomNavigationBarIndex == homeTab) {
      //  home
      body = Home(nordicNrfMesh: nordicNrfMesh);
    } else if (_bottomNavigationBarIndex == provisioningTab) {
      //  scanning & provisionning
      body = ScanningAndProvisioning(
          nordicNrfMesh: nordicNrfMesh,
          onGoToControl: () {
            setState(() {
              _bottomNavigationBarIndex = controlTab;
            });
          });
    } else if (_bottomNavigationBarIndex == controlTab) {
      //  List provisioned devices and then can control/setup them
      body = ProvisionedDevices(nordicNrfMesh: nordicNrfMesh);
    }

    return MaterialApp(
      home: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          appBar: AppBar(),
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavigationBarIndex,
            onTap: (newBottomNavigationBarIndex) {
              if (nordicNrfMesh.meshManagerApi.meshNetwork != null) {
                setState(() {
                  _bottomNavigationBarIndex = newBottomNavigationBarIndex;
                });
              } else {
                _scaffoldKey.currentState!.clearSnackBars();
                _scaffoldKey.currentState!.showSnackBar(const SnackBar(content: Text('Please load a mesh network')));
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bluetooth_searching),
                label: 'Provisioning',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: 'Control',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

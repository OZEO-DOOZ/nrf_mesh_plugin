# nordic_nrf_mesh
[![pub version]](https://pub.dev/packages/nordic_nrf_mesh) [![pub points]](https://pub.dev/packages/nordic_nrf_mesh/score) [![pub likes]](https://pub.dev/packages/nordic_nrf_mesh/score) [![pub popularity]](https://pub.dev/packages/nordic_nrf_mesh/score)

A Flutter plugin to enable mesh network management and communication using Nordic Semiconductor's SDKs.
# Features
This plugin wraps both [IOS-nRF-Mesh-Library] and [Android-nRF-Mesh-Library] to provide a Dart-only API and has the following features :
- Create, load and manage a mesh network model
- (de)provision a BLE mesh node
- Scan for BLE devices in range
- Connect to a BLE mesh node and use it as a proxy to communicate in a mesh network
- Encrypt and decrypt mesh PDUs (not all mesh message types are supported)
- Event based API using [StreamControllers]
- Manage mesh groups
- Manage nodes' publications and subscriptions
- Manage mesh provisioners
- Key Refresh Procedure ([partial support on Android](https://github.com/OZEO-DOOZ/nrf_mesh_plugin/pull/199))

_(Note: the Bluetooth scanning and connecting features are done with [flutter_reactive_ble])_
# How to use
## Initialization
To begin to use the plugin, one should instantiate the `NordicNrfMesh` instance like so :
```dart
final nordicNrfMesh = NordicNrfMesh();
```
It's via this singleton that one may have access to the main API.
## Mesh network features
To be able to use the mesh features, please make sure to load a mesh network at each run like so :
```dart
final MeshManagerApi meshManager = nordicNrfMesh.meshManagerApi;
final MeshNetwork meshNetwork = await meshManager.loadMeshNetwork();
```
_or_
```dart
final String networkAsJson = '{"mesh": "network"}';
final MeshManagerApi meshManager = nordicNrfMesh.meshManagerApi;
final MeshNetwork meshNetwork = await meshManager.importMeshNetworkJson(networkAsJson);
```
Getting the network via the result of these two methods is the easy way. However it won't be updated on events and so we strongly advise users to use the event streams like so :
```dart
class MyPluginWrapper{
  late IMeshNetwork? _meshNetwork;
  late final MeshManagerApi _meshManagerApi;
  late final StreamSubscription<IMeshNetwork?> onNetworkUpdateSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkImportSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkLoadingSubscription;

  void init() {
    _meshManagerApi = widget.nordicNrfMesh.meshManagerApi;
    _meshNetwork = _meshManagerApi.meshNetwork;
    onNetworkUpdateSubscription = _meshManagerApi.onNetworkUpdated.listen((event) {
      _meshNetwork = event;
    });
    onNetworkImportSubscription = _meshManagerApi.onNetworkImported.listen((event) {
      _meshNetwork = event;
    });
    onNetworkLoadingSubscription = _meshManagerApi.onNetworkLoaded.listen((event) {
      _meshNetwork = event;
    });
  }

  void dispose() {
    onNetworkUpdateSubscription.cancel();
    onNetworkLoadingSubscription.cancel();
    onNetworkImportSubscription.cancel();
  }
}
```
Basically these two ways to get a result tend to be there in each methods of the plugin. For example :
- you can await a call to `MeshManagerApi.sendGenericLevelSet`, but also just call it, and having a stream subscription on `MeshManagerApi.onGenericLevelStatus` running in the background.
- you can await a connection or ask for it and listen to resulting events in the given `BleManagerCallbacks`

_(If it's not the case and you'd want it implemented, feel free to open an [Issue] or a [Pull Request])_
### (de)provisioning
For a node to be part of a network, it must be provisioned. This critical feature is available via the `NordicNrfMesh` instance.
Here are the signatures :
```dart
Future<ProvisionedMeshNode> provisioning(
  final MeshManagerApi meshManagerApi,
  final BleMeshManager bleMeshManager,
  final DiscoveredDevice device,
  final String serviceDataUuid, {
  final ProvisioningEvent? events,
})
```
```dart
Future<ConfigNodeResetStatus> deprovision(
  final MeshManagerApi meshManagerApi,
  final ProvisionedMeshNode meshNode,
)
```
_For example usage, please refer to example app._
## Bluetooth features
_(Note: the Bluetooth scanning and connecting features are done with [flutter_reactive_ble])_
### Scan devices :
The different scanners are available via the `NordicNrfMesh` instance. The API is mesh oriented so you can easily get the mesh devices around the phone, but you can still have custom scanning via `NordicNrfMesh.scanWithServices`.
### Connect to a device :
In order to implement connection features, one must use the `BleManager` and `BleManagerCallbacks` abstract classes.

For convenience, we ship this plugin with an implementation specific to mesh nodes. To be able to handle BLE connection with a **mesh proxy node**, one shall create and initialize a `BleMeshManager` instance.
```dart
final bleMeshManager = BleMeshManager();
bleMeshManager.callbacks = MyBleCallbacks(meshManager); // must be set
```
_(The `MyBleCallbacks` in the snippet above must extends `BleMeshManagerCallbacks`.)_

After that, you will have to scan for devices, and then call the `connect` method like so :
```dart
DiscoveredDevice device;
// scan for device in range
[...]
// connect if found
bleMeshManager.connect(device);
```
### Custom BLE features :
If your use case is not implemented, you should prioritize opening an [Issue] for a feature request. However you can still get access to other features of the [flutter_reactive_ble] plugin by getting its singleton instance using the following snippet :
```dart
final blePlugin = FlutterReactiveBle();
```
Again, this should not be done by you, feel free to ask us to implement a new method/feature ! :)
## Example app
For more in depth use, please refer to example app which shows some of the most used features.
In a tab based layout, it provides example usage on :
 - basic mesh network management
 - scanning and provisioning a new node with some event based ui
 - scanning, connecting and sending messages to provisioned nodes
 # Related links
- [Android-nRF-Mesh-Library] ([fork](https://github.com/OZEO-DOOZ/Android-nRF-Mesh-Library-1))
- [iOS-nRF-Mesh-Library] ([fork](https://github.com/OZEO-DOOZ/IOS-nRF-Mesh-Library))
- [Bluetooth Mesh Profile v1.0.1]
- [flutter_reactive_ble]

(Note: This plugin uses forks of Nordic Semiconductor's libraries. This has been done to be able to extend these libraries with some DooZ specific API, but doesn't change the source code)

[Issue]: https://github.com/OZEO-DOOZ/nrf_mesh_plugin/issues
[Pull Request]: https://github.com/OZEO-DOOZ/nrf_mesh_plugin/pulls
[StreamControllers]: https://api.dart.dev/stable/dart-async/StreamController-class.html
[Android-nRF-Mesh-Library]: https://github.com/NordicSemiconductor/Android-nRF-Mesh-Library
[iOS-nRF-Mesh-Library]: https://github.com/NordicSemiconductor/IOS-nRF-Mesh-Library
[flutter_reactive_ble]: https://pub.dev/packages/flutter_reactive_ble
[Bluetooth Mesh Profile v1.0.1]: https://www.bluetooth.com/specifications/specs/mesh-profile-1-0-1/
[pub version]: https://img.shields.io/pub/v/nordic_nrf_mesh.svg
[pub points]: https://badges.bar/nordic_nrf_mesh/pub%20points
[pub likes]: https://badges.bar/nordic_nrf_mesh/likes
[pub popularity]: https://badges.bar/nordic_nrf_mesh/popularity
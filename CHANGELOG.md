## 0.12.0

- Use of Nordic Semiconductor's Android SDK v3.1.9
- Upgraded Gradle version and dependencies
- Upgraded Dart dependencies

## 0.11.0

- Use of Nordic Semiconductor's Android SDK v3.1.8
- Updated example app
- Updated readme

## 0.10.1

- fix pubspec issue seen by `flutter pub publish --dry-run`

## 0.10.0

First open source release ! :rocket:

- add missing documentation
- remove unused API and dependency
- refresh `example/`, `ios/` and `android/` folders to be up to date with the latest Flutter version (2.10.3)

## 0.9.1

- revert app's manifest changes

## 0.9.0

- compile against Android 12 (API 31) and update BLE permissions in app's manifest

## 0.8.0

- Add DooZ scenario protocol V2 messages. `DoozEpochSet` and `DoozEpochStatus` are tested on both platforms, whereas `DoozScenarioSet` and `DoozScenarioStatus` are added in Android version but not used for now (prepare for next release)
- Expose `ConfigModelPublicationGet` msg
- Use of Nordic's Android SDK v3.1.7
- Use of Nordic's iOS SDK v3.1.5

## 0.7.0

- added getter for `BleStatus`
- provisioning events now pass the target BLE device data
- workflow `on_pr.yml` now forces Flutter version to 2.5.3

## 0.6.0

- fix bug in adding a provisioner on iOS device
- expose ConfigBeacon API
- negociate MTU before enabling notifications (Fix bug on Android where Secure Network Beacons were truncated)
- Ignore timing criterias to accept an incoming Secure Network Beacon (useful when network has just been loaded from its JSON representation in which the IV Index last transition date is not stored)
- `searchForSpecificNode` will now return a result if the given String matches the device's id **or** name

## 0.5.0

- expose some of the API needed to execute a Key Refresh Procedure on Android using [this](https://github.com/NordicSemiconductor/Android-nRF-Mesh-Library/pull/381) Pull Request as reference
- allow to choose the name of a provisioner when asking to create one using `IMeshNetwork.addProvisioner` method (defaults to `'DooZ Mesh Provisioner'`)

## 0.4.0

- added a new scanning method where a user may choose the BLE services to look for
- implement a whitelist parameter in BleManager.connect method. Useful when using iOS device and consumer know in advance which MAC addresses belong to the loaded **DooZ** mesh network
- added new error codes for BleManagerFailureCode related to the DooZ custom BLE service
- migrate Gradle build script artifacts repository from`jcenter()` to `mavenCentral()`
- fix `GetV2MagicLevelArguments` `correlation` parameter data type

## 0.3.0

- now use flutter_reactive_ble v4.0.1
- added iOS support
- added new error code for BleManagerFailureCode enum for the case where we get a disconnection event before device is ready for communication
- added handler for UndeliverableException to avoid app crashes if a BLE event occurs without any attached listener
- during provisioning process, connection auto retry now handles one more case which is when we fail to work with BLE charac notifications
- minimum iOS version is now 11.0
- work on reading DooZ custom BLE characteristic so we can read MAC even on iOS

## 0.2.1

- fix Completer error if error occurs during gatt data out stream subscription
- add more error codes for provisioning failure + update docs
- fix unhandled disconnection event during provisioning
- fix bug in disconnection event handlers

## 0.2.0

- Work on error handling for BleManager and BleMeshManager. Implement two ways to handle errors for the consumer : either by asynchronous errors, or with dedicated StreamControllers that, if defined, would propagate any error
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
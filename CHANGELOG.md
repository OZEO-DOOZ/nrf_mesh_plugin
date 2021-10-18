## 0.2.2

- added new error code for BleManagerFailureCode enum for the case where we get a disconnection event before device is ready for communication

## 0.2.1

- fix Completer error if error occurs during gatt data out stream subscription
- add more error codes for provisioning failure + update docs
- fix unhandled disconnection event during provisioning
- fix bug in disconnection event handlers

## 0.2.0

- Work on error handling for BleManager and BleMeshManager. Implement two ways to handle errors for the consumer : either by asynchronous errors, or with dedicated StreamControllers that, if defined, would propagate any error
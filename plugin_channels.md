# Plugin channels

This document lists the channels used by the plugin, as well as their respective methods and errors

## Generic errors
All methods can throw a `notImplemented` error if the native plugin doesn't listen to it.

The methods that requires parameters can throw two more errors:


`missingArguments`

`errorDecoding`
    

## PluginMethodChannel
### getPlatformVersion

```
await widget.nordicNrfMesh.platformVersion;
```

This method returns a string e.g. `"iOS 11.0"`

## DoozMeshManagerApiChannel

### loadMeshNetwork

Loads the Mesh Network configuration from the storage.

```
meshManagerApi.loadMeshNetwork();
```

This method returns nothing

##### Listen to `onNetworkLoaded` for getting asynchrone result

Format :

```
{ 
	eventName: onNetworkLoaded
	id: $network.meshUuid
}
```

##### Listen to `onNetworkLoadFailed` for getting asynchrone failure


Format :

```
{ 
	eventName: onNetworkLoadFailed
	error: $error
}
```

###### Possible errors :

+ loading fails
+ add appKey fails (when generating)
	+ MeshNetworkError.invalidKey
   	+ MeshNetworkError.noNetworkKey
	+ MeshNetworkError.keyIndexOutOfRange

+ saving network fails (when generating)
+ network is null after loading or generating (should not happen)





	case dataCorrupted(DecodingError.Context)
An indication that the data is corrupted or otherwise invalid.

	case keyNotFound(CodingKey, DecodingError.Context)
An indication that a keyed decoding container was asked for an entry for the given key, but did not contain one.

	case typeMismatch(Any.Type, DecodingError.Context)
An indication that a value of the given type could not be decoded because it did not match the type of what was found in the encoded payload.

	case valueNotFound(Any.Type, DecodingError.Context)
An indication that a non-optional value of the given type was expected, but a null value was found.


### ✅ importMeshNetworkJson(_ data: ImportMeshNetworkJsonArguments)

Imports the Mesh Network configuration from the given Data.


```
await meshManagerApi.importMeshNetworkJson(json);
```

This method returns nothing

#### Parameters

```
{ 
	json: String 
}
```

##### Listen to `onNetworkImported ` for getting asynchrone result

Format :

```
{ 
	eventName: onNetworkImported
	id: $network.meshUuid
}
```

##### Listen to `onNetworkImportFailed` for getting asynchrone failure


Format :

```
{ 
	eventName: onNetworkImportFailed
	error: $error
}
```

Possible errors :

	case dataCorrupted(DecodingError.Context)
An indication that the data is corrupted or otherwise invalid.

	case keyNotFound(CodingKey, DecodingError.Context)
An indication that a keyed decoding container was asked for an entry for the given key, but did not contain one.

	case typeMismatch(Any.Type, DecodingError.Context)
An indication that a value of the given type could not be decoded because it did not match the type of what was found in the encoded payload.

	case valueNotFound(Any.Type, DecodingError.Context)
An indication that a non-optional value of the given type was expected, but a null value was found.


### ✅ deleteMeshNetworkFromDb(_ data: DeleteMeshNetworkFromDbArguments)

🚧🚧🚧 Not implemented in sample app 🚧🚧🚧

Use this to delete the local database

This method returns nothing

#### Parameters

```
{ 
	id: String 
}
```

🚧🚧🚧 Delete callbacks not implemented 🚧🚧🚧

<!--##### Listen to `onNetworkImportFailed` for getting asynchrone failure


Format :

```
{ 
	eventName: onNetworkImportFailed
	error: $error
}
```

pour iOS : custom error storageFileDoesNotExists

-->


### ✅ exportMeshNetwork

Returns the exported Mesh Network configuration as a string UTF8 encoded.
The returned Data can be transferred to another application and
imported. The JSON is compatible with Bluetooth Mesh scheme.

```
meshManagerApi.exportMeshNetwork();
```

🚧🚧🚧 Export callbacks not implemented 🚧🚧🚧

JSONEncoder.encode() errors :

	case invalidValue(Any, EncodingError.Context)
An indication that an encoder or its containers could not encode the given value.


### ✅ identifyNode(_ data: IdentifyNodeArguments)

This method initializes the provisioning of the device.

#### Parameters

```
{ 
	serviceUuid: String 
}
```

Possible errors : 

+ create ProvisioningManager :

		MeshNetworkError.noNetwork 

+ identify :
	
		  // Does the Bearer support provisioning?
        guard bearer.supports(.provisioningPdu) else {
            logger?.e(.provisioning, "Bearer does not support provisioning PDU")
            throw BearerError.pduTypeNotSupported
        }
        
        // Has the provisioning been restarted?
        if case .fail = state {
            reset()
        }
        
        // Is the Provisioner Manager in the right state?
        guard case .ready = state else {
            logger?.e(.provisioning, "Provisioning manager is in invalid state")
            throw ProvisioningError.invalidState
        }
        
        // Is the Bearer open?
        guard bearer.isOpen else {
            logger?.e(.provisioning, "Bearer closed")
            throw BearerError.bearerClosed
        }
    
+ send provisioningInvite :

    		guard supports(type) else {
            throw BearerError.pduTypeNotSupported
        }
        guard isOpen else {
            throw BearerError.bearerClosed
        }
        guard let dataInCharacteristic = dataInCharacteristic else {
            throw GattBearerError.deviceNotSupported
        } 

### ✅ handleNotifications(_ data: HandleNotificationsArguments)

Callback called when a packet has been received using the Bearer.

```
meshManagerApi.handleNotifications(event.mtu, event.pdu);
```

This method returns nothing

#### Parameters

```
{ 
	mtu: Int
	pdu: Data
}
```

Possible errors :

🚧 Not implemented 🚧

+ we could have an unknownPdu	error, but nothing else on iOS side. The native method doesn't throw and returns void.
		


### ✅ setMtuSize(_ data: MtuSizeArguments)
 
This method returns nothing

#### Parameters

```
{ 
	mtuSize: Int
}
```

🚧 Useless on iOS ? To verify 🚧

### ✅ cleanProvisioningData

This method reset the unprovisionedDevices list from the current provisioner.

This method returns nothing, no errors are thrown

### ✅ provisioning
This method starts the provisioning of the device.
'identifyNode' must be called prior to this to receive the device capabilities

##### Listen to `onProvisioningCompleted` for getting asynchrone result

##### Listen to `onProvisioningFailed` for getting asynchrone result

	CFErrors on calculateSharedSecret() if needed, not implemented for now
	
    /// Thrown when the ProvisioningManager is in invalid state.
	    case invalidState
    /// The received PDU is invalid.
   		 case invalidPdu
    /// Thrown when an unsupported algorighm has been selected for provisioning.
	    case unsupportedAlgorithm
    /// Thrown when the Unprovisioned Device is not supported by the manager.
   		 case unsupportedDevice
    /// Thrown when the provided alphanumberic value could not be converted into
    /// bytes using ASCII encoding.
	    case invalidOobValueFormat
    /// Thrown when no available Unicast Address was found in the Provisioner's
    /// range that could be allocated for the device.
   		 case noAddressAvailable
    /// Throws when the Unicast Address has not been set.
	    case addressNotSpecified
    /// Throws when the Network Key has not been set.
   		 case networkKeyNotSpecified
    /// Thrown when confirmation value received from the device does not match
    /// calculated value. Authentication failed.
   		 case confirmationFailed
    /// Thrown when the remove device sent a failure indication.
	   	 case remoteError(_ error: RemoteProvisioningError)
    /// Thrown when the key pair generation has failed.
	    case keyGenerationFailed(_ error: OSStatus)


##### Listen to `onProvisioningStateChanged` for getting asynchrone result

🚧🚧🚧 Uniformiser ou retirer si inutile 🚧🚧🚧

		 case .capabilitiesReceived(_):
            return "PROVISIONING_CAPABILITIES"
        case .ready:
            return "PROVISIONER_READY"
        case .requestingCapabilities:
            return "REQUESTING_CAPABILITIES"
        case .provisioning:
            return "PROVISIONING"
        default:
            return ""
Errors : 

+ Custom :

	`DoozProvisioningManagerError.provisioningManagerDoesNotExist`

        
+ All the bearer.send errors

        guard supports(type) else {
            throw BearerError.pduTypeNotSupported
        }
        guard isOpen else {
            throw BearerError.bearerClosed
        }
        guard let dataInCharacteristic = dataInCharacteristic else {
            throw GattBearerError.deviceNotSupported
        }
        guard let networkManager = networkManager, let meshNetwork = meshNetwork else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        guard let localNode = meshNetwork.localProvisioner?.node,
              let source = localElement ?? localNode.elements.first else {
            print("Error: Local Provisioner has no Unicast Address assigned")
            throw AccessError.invalidSource
        }
        guard source.parentNode == localNode else {
            print("Error: The Element does not belong to the local Node")
            throw AccessError.invalidElement
        }
        guard initialTtl == nil || initialTtl == 0 || (2...127).contains(initialTtl!) else {
            print("Error: TTL value \(initialTtl!) is invalid")
            throw AccessError.invalidTtl
        }
        
### ✅ createMeshPduForConfigCompositionDataGet(_ data: CreateMeshPduForConfigCompositionDataGetArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	dest: Int16
}
```

[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onConfigCompositionDataStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigCompositionDataStatus"
	source: UInt16
	message: {
		source: UInt16
		destination: UInt16
	}
}
```

            
### ✅ createMeshPduForConfigAppKeyAdd(_ data: CreateMeshPduForConfigAppKeyAddArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	dest: Int16
}
```

[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onConfigAppKeyStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigAppKeyStatus"
	source: UInt16
	message: {
		source: UInt16
		destination: UInt16
	}
}
```

### ✅ sendConfigModelAppBind(_ data: SendConfigModelAppBindArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	nodeId: Int16
	elementId: Int16
	modelId: UInt32
	appKeyIndex: Int16
}
```

[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onConfigModelAppStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigModelAppStatus"
	elementAddress: UInt16
	modelId: UInt16
	appKeyIndex: UInt16
}
```

### ✅ sendGenericLevelSet(_ data: SendGenericLevelSetArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	address: Int16
	level: Int16
	keyIndex: Int16
}
```
    
[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onGenericLevelStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onGenericLevelStatus"
	level: Int16
	targetLevel: Int16 // default is 0 ❌
	source: UInt16
	destination: UInt16
}
```

🚧🚧🚧 Standardize source + destination with key "message: {source:destination:}" as in other messages callbacks ? 🚧🚧🚧


### ✅ sendGenericOnOffSet(_ data: SendGenericOnOffSetArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	address: Int16
	value: Bool
	keyIndex: Int16
}
```

[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onGenericOnOffStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigModelAppStatus"
	elementAddress: UInt16
	modelId: UInt16
	appKeyIndex: UInt16
}
```

### ✅ sendConfigModelSubscriptionAdd(_ data: SendConfigModelSubscriptionAddArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	address: Int16
	elementAddress: Int16
	subscriptionAddress: Int16
	modelIdentifier: UInt32
}
```
    
[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onConfigModelSubscriptionStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigModelAppStatus"
	elementAddress: UInt16
	modelId: UInt16
	appKeyIndex: UInt16
}
```

### ✅ sendConfigModelSubscriptionDelete(_ data: SendConfigModelSubscriptionDeleteArguments)

This method returns nothing

🚧🚧🚧 Standardize name "create" vs "send" between different messages methods ? 🚧🚧🚧

#### Parameters

```
{ 
	address: Int16
	elementAddress: Int16
	subscriptionAddress: Int16
	modelIdentifier: UInt32
}
```
    
[Listen to `onMeshPduCreated` to get the message to send via FlutterBlue](#onMeshPduCreated)

##### Listen to `onConfigModelSubscriptionStatus` for getting asynchrone result

Format :

```
{ 
	eventName: "onConfigModelAppStatus"
	elementAddress: UInt16
	modelId: UInt16
	appKeyIndex: UInt16
}
```

### ✅ getSequenceNumberForAddress(_ data: GetSequenceNumberForAddressArguments)

Returns sequence number of the element with specified address

#### Parameters

```
{ 
	address: Int16
}
```

Errors :

network does not exist
node with specified address does not exist
     
### ✅ error(_ error: Error)

If method isn't implemented in native part

    notImplemented
    
Errors on arguments:

    missingArguments
    errorDecoding

## DoozMeshNetworkChannel
### ✅ getId

```
await meshManagerApi.meshNetwork.meshUUID;
```

Returns meshNetwork.meshUUID as String or null ❌

No errors thrown

### ✅ getMeshNetworkName

```
await meshManagerApi.meshNetwork.name;
```

Returns meshNetwork.name as String or null ❌

No errors thrown

### ✅ highestAllocatableAddress

```
await meshManagerApi.meshNetwork.highestAllocatableAddress;
```

Returns the highestAllocatableAddress as Int. Default is 0. ❌

No errors thrown

### ✅ nodes
```
await meshManagerApi.meshNetwork.nodes;
```

Returns an array of provisioned nodes uuid

Format :

```
[
	{ 
		uuid: String
	},
	{
		...
	}
]
```

EventSinkKeys.network.uuid.rawValue: device.node.uuid.uuidString

No errors thrown

### ✅ selectedProvisionerUuid

```
await widget.meshManagerApi.meshNetwork.selectedProvisionerUuid();
```

Returns meshNetwork.localProvisioner.uuid.uuidString as String or null ❌

No errors thrown

### ✅ addGroupWithName(_ data: AddGroupWithNameArguments)

```
await widget.meshManagerApi.meshNetwork.addGroupWithName(name)
```

Adds a new Group to the network.

#### Parameters
```
{ 
	name: String 
}
```

Returns the newly added group infos

Format :

```
{
	group: {
		name: String,
		address: UInt16,
		addressLabel: String,
		parentAddress: UInt16,
		parentAddressLabel: String
	},
	successfullyAdded: Bool

}
```

Errors:
	
	throw MeshNetworkError.groupAlreadyExists

### ✅ groups

```
await meshManagerApi.meshNetwork.groups;
```

Returns an array of the meshNetwork groups infos

Format :

```
[
	group: {
		name: String,
		address: UInt16,
		addressLabel: String,
		parentAddress: UInt16,
		parentAddressLabel: String
	},
	{
		...
	}
]
```

No errors thrown

### ✅ removeGroup(_ data: RemoveGroupArguments)

Remove the Group from the network.

```
await widget.meshManagerApi.meshNetwork.removeGroup(parameters)
```

Returns a boolean (true if removed, false otherwise)


#### Parameters
```
{ 
	groupAddress: Int16
}
```

Errors:

> throw MeshNetworkError.groupInUse
> group does not exist 🚧 Not implemented 🚧

### ✅ getElementsForGroup(_ data: GetElementsForGroupArguments)


```
await meshNetwork.elementsForGroup(parameters)
```

Returns an array of the designated group elements infos


#### Parameters
```
{ 
	address: Int16
}
```
🚧🚧🚧 Standardize key between getElementsForGroup and removeGroup (address vs groupAddress) 🚧🚧🚧

Errors:

> throw MeshNetworkError.groupInUse
> group does not exist 🚧 Not implemented, that's a possibility 🚧


## DoozProvisionedMeshNodeChannel

### ✅ unicastAddress
```
await node.unicastAddress;
```

Returns the unicastAddress of the node as UInt16

No errors thrown

### ✅ nodeName(_ data: NodeNameArguments)

Set the name of a node

```
await node.nodeName(parameters);
```

#### Parameters
```
{ 
	address: Int16
}
```

Returns nothing

No errors thrown

🚧🚧🚧 We should return a boolean indicating if the method succeed or failed (can we know it ?) 🚧🚧🚧

### ✅ name
```
await node.name;
```

Returns the name of the node as String ❌ default is null

No errors thrown 

### ✅ elements

```
await node.elements;
```

Returns an array of the node's elements infos

Format :

```
[
	key: UInt8, // Numeric order of the Element within this Node.
   	address: UInt16,
   	locationDescriptor: UInt16,
	models: [
		key: UInt8,
		modelId: UInt16,
		subscribedAddresses: [
			UInt16,
			...
		],
		boundAppKey: [
			UInt8,
			...
		]
	],
	...   
]
```

No errors thrown

### ✅ elementAt

🚧 Not implemented 🚧


## DoozUnprovisionedMeshNodeChannel

### ✅ getNumberOfElements

```
await unprovisionedMeshNode.getNumberOfElements();
```

Returns the number of elements of this unprovisionedDevice as UInt8


# onMeshPduCreated

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```

Response : 

	bleMeshManager.callbacks.onDataReceived(mtu, pdu)
> This call is dispatched to handleNotification for native processing

> The native part is responding through the methods calls respective response (onConfigModelAppStatus / onConfigCompositionDataStatus etc...)

> See each method documentation for information about the response event name.
	

Possible errors :


+ All the errors priori to bearer.send :

        guard let networkManager = networkManager, let meshNetwork = meshNetwork else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        guard let localNode = meshNetwork.localProvisioner?.node,
              let source = localElement ?? localNode.elements.first else {
            print("Error: Local Provisioner has no Unicast Address assigned")
            throw AccessError.invalidSource
        }
        guard source.parentNode == localNode else {
            print("Error: The Element does not belong to the local Node")
            throw AccessError.invalidElement
        }
        guard initialTtl == nil || initialTtl == 0 || (2...127).contains(initialTtl!) else {
            print("Error: TTL value \(initialTtl!) is invalid")
            throw AccessError.invalidTtl
        }
        
        
        
        
        
        
        
        
        
        
        



# iOS Errors

## MeshNetworkError
	public enum MeshNetworkError: Error {
	    /// Thrown when any allocated range of the new Provisioner overlaps
	    /// with existing one.
	    case overlappingProvisionerRanges
	    /// Thrown when trying to add a Provisioner that is already a part
	    /// of another mesh network.
	    case provisionerUsedInAnotherNetwork
	    /// Thrown when a new Provisioner has the same UUID as one node that
	    /// is already in the mesh network.
	    case nodeAlreadyExist
	    /// Thrown when a node cannot be added due to lack of available
	    /// addresses in Provisioner's range.
	    case noAddressAvailable
	    /// Thrown when the address cannot be assigne as it is being used by
	    /// another node.
	    case addressNotAvailable
	    /// Thrown when the address is of a wrong type.
	    case invalidAddress
	    /// Thrown when a node cannot be added due to its address not being
	    /// inside Provisioner's unicast address range.
	    case addressNotInAllocatedRange
	    /// Thrown when the requested Provisioner is not in the Mesh Network.
	    case provisionerNotInNetwork
	    /// Thrown when the range to be allocated is of invalid type.
	    case invalidRange
	    /// Thrown when the provided key is not 128-bit long.
	    case invalidKey
	    /// Thrown when trying to remove a key that is being used by some node.
	    case keyInUse
	    /// Thrown when a new Group is being added with the same address as one
	    /// that is already in the network.
	    case groupAlreadyExists
	    /// Throw when trying to remove a Group that is either a parent of another
	    /// Group, or set as publication or subcription address for any Model.
	    case groupInUse
	    /// Thrown when the given Key Index is not valid.
	    case keyIndexOutOfRange
	    /// Thrown when Network Key is required to continue with the operation.
	    case noNetworkKey
	    /// Thrown when Application Key is required to continue with the operation.
	    case noApplicationKey
	    /// Thrown when trying to send a mesh message before setting up the mesh network.
	    case noNetwork
	}

## MeshMessageError
	public enum MeshMessageError: Error {
	    case invalidAddress
	    case invalidPdu
	    case invalidOpCode
	}

## LowerTransportError
	public enum LowerTransportError: Error {
	    /// The segmented message has not been acknowledged before the timeout occurred.
	    case timeout
	    /// The target device is busy at the moment and could not accept the message.
	    case busy
	    /// Thrown internally when a possible replay attack was detected.
	    /// This error is not propagated to higher levels, the packet is
	    /// being discarded.
	    case replayAttack
	}
	
## GattBearerError
	public enum GattBearerError: Error {
	    /// The connected device does not have services required
	    /// by the Bearer.
	    case deviceNotSupported
	}

## BearerError
	public enum BearerError: Error {
	    /// Thrown when the Central Manager is not in ON state.
	    case centralManagerNotPoweredOn
	    /// Thrown when the given PDU type is not supported
	    /// by the Bearer.
	    case pduTypeNotSupported
	    /// Thrown when the Bearer is not ready to send data.
	    case bearerClosed
	}

## AccessError
	public enum AccessError: Error {
	    /// Error thrown when the local Provisioner does not have
	    /// a Unicast Address specified and is not able to send
	    /// requested message.
	    case invalidSource
	    /// Thrown when trying to send a message using an Element
	    /// that does not belong to the local Provisioner's Node.
	    case invalidElement
	    /// Throwm when the given TTL is not valid. Valid TTL must
	    /// be 0 or in range 2...127.
	    case invalidTtl
	    /// Thrown when the destination Address is not known and the
	    /// library cannot determine the Network Key to use.
	    case invalidDestination
	    /// Thrown when trying to send a message from a Model that
	    /// does not have any Application Key bound to it.
	    case modelNotBoundToAppKey
	    /// Error thrown when the Provisioner is trying to delete
	    /// the last Network Key from the Node.
	    case cannotDelete
	    /// Thrown, when the acknowledgment has not been received until
	    /// the time run out.
	    case timeout
	}
	
## Custom errors
	enum FlutterCallError: Error{
	    case missingArguments
	    case notImplemented
	    case errorDecoding
	}
	
	enum DoozMeshManagerApiError: Error{
	    case errorLoadingMeshNetwork
	    case errorSavingMeshNetwork
	}
	

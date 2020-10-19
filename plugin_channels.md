#Plugin channels

This document lists the channels used by the plugin, as well as their respective methods and errors

## Generic errors
All methods can throw a `notImplemented` error if the plugin doesn't listen to it.

The methods that requires parameters can throw two more errors:


`missingArguments`

`errorDecoding`
    

##PluginMethodChannel
### ✅ getPlatformVersion

```
await widget.nordicNrfMesh.platformVersion;
```

This method returns a string e.g. `"iOS 11.0"`

### ✅ createMeshManagerApi

```
widget.nordicNrfMesh.meshManagerApi;
```

This method returns nothing, no errors is thrown

🚧🚧🚧 

Is there a possible failure here ? 

🚧🚧🚧



##DoozMeshManagerApiChannel

### ✅ loadMeshNetwork

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
	id: $network.id
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

Possible errors :

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
	id: $network.id
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

#### Parameters

```
{ 
	dest: Int16
}
```

[Listen to `onMeshPduCreated` for getting asynchrone result](#onMeshPduCreated)

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```

Possible errors :


+ All the bearer.send errors

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
        
### ✅ createMeshPduForConfigAppKeyAdd(_ data: CreateMeshPduForConfigAppKeyAddArguments)

This method returns nothing

#### Parameters

```
{ 
	dest: Int16
}
```

##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```

### ✅ sendConfigModelAppBind(_ data: SendConfigModelAppBindArguments)

This method returns nothing

#### Parameters

```
{ 
	nodeId: Int16
	elementId: Int16
	modelId: UInt32
	appKeyIndex: Int16
}
```

    
##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```
### ✅ sendGenericLevelSet(_ data: SendGenericLevelSetArguments)

This method returns nothing

#### Parameters

```
{ 
	address: Int16
	level: Int16
	keyIndex: Int16
}
```

    
##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```
### ✅ sendGenericOnOffSet(_ data: SendGenericOnOffSetArguments)

This method returns nothing

#### Parameters

```
{ 
	address: Int16
	value: Bool
	keyIndex: Int16
}
```
    
##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```
### ✅ sendConfigModelSubscriptionAdd(_ data: SendConfigModelSubscriptionAddArguments)

This method returns nothing

#### Parameters

```
{ 
	address: Int16
	elementAddress: Int16
	subscriptionAddress: Int16
	modelIdentifier: UInt32
}
```
    
##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```
### ✅ sendConfigModelSubscriptionDelete(_ data: SendConfigModelSubscriptionDeleteArguments)

This method returns nothing

#### Parameters

```
{ 
	address: Int16
	elementAddress: Int16
	subscriptionAddress: Int16
	modelIdentifier: UInt32
}
```
    
##### Listen to `onMeshPduCreated` for getting asynchrone result

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
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
     
### ✅ error(_ error: Error)

## DoozMeshNetworkChannel
### ✅ getId
### ✅ getMeshNetworkName
### ✅ highestAllocatableAddress
### ✅ nodes
### ✅ selectedProvisionerUuid
### ✅ addGroupWithName(_ data: AddGroupWithNameArguments)
### ✅ groups
### ✅ removeGroup(_ data: RemoveGroupArguments)
### ✅ getElementsForGroup(_ data: GetElementsForGroupArguments)




## DoozProvisionedMeshNodeChannel
### ✅ unicastAddress
### ✅ nodeName(_ data: NodeNameArguments)
### ✅ name
### ✅ elements
### ✅ elementAt

## DoozUnprovisionedMeshNodeChannel
### ✅ getNumberOfElements



# onMeshPduCreated

Format :

```
{ 
	eventName: onMeshPduCreated
	pdu: $data
}
```

Possible errors :


+ All the bearer.send errors

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
#Plugin channels

This document lists the channels used by the plugin, as well as their respective methods and errors

##DoozMeshManagerApiChannel

+ loadMeshNetwork
> Loads the Mesh Network configuration from the storage.

    
+ importMeshNetworkJson(_ data: ImportMeshNetworkJsonArguments)
> Imports the Mesh Network configuration from the given Data.

+ deleteMeshNetworkFromDb(_ data: DeleteMeshNetworkFromDbArguments)
> Use this to delete the local database

+ exportMeshNetwork
> Returns the exported Mesh Network configuration as JSON Data.
> The returned Data can be transferred to another application and
> imported. The JSON is compatible with Bluetooth Mesh scheme.

+ identifyNode(_ data: IdentifyNodeArguments)
> This method initializes the provisioning of the device.

+ handleNotifications(_ data: HandleNotificationsArguments)
> Callback called when a packet has been received using the Bearer.

+ setMtuSize(_ data: MtuSizeArguments)
> 

+ cleanProvisioningData
> This method reset the unprovisionedDevices list from the current provisioner.

+ provisioning
> This method starts the provisioning of the device.
> 'identifyNode' must be called prior to this to receive the device capabilities

+ createMeshPduForConfigCompositionDataGet(_ data: CreateMeshPduForConfigCompositionDataGetArguments)
> Returns a ConfigCompositionDataGet

+ createMeshPduForConfigAppKeyAdd(_ data: CreateMeshPduForConfigAppKeyAddArguments)
> Returns a ConfigAppKeyAdd

+ sendConfigModelAppBind(_ data: SendConfigModelAppBindArguments)
> Returns a ConfigModelAppBind

+ sendGenericLevelSet(_ data: SendGenericLevelSetArguments)


+ sendGenericOnOffSet(_ data: SendGenericOnOffSetArguments)


+ sendConfigModelSubscriptionAdd(_ data: SendConfigModelSubscriptionAddArguments)


+ sendConfigModelSubscriptionDelete(_ data: SendConfigModelSubscriptionDeleteArguments)
     
+ getSequenceNumberForAddress(_ data: GetSequenceNumberForAddressArguments)
     
+ error(_ error: Error)

##DoozMeshNetworkChannel
+ getId
+ getMeshNetworkName
+ highestAllocatableAddress
+ nodes
+ selectedProvisionerUuid
+ addGroupWithName(_ data: AddGroupWithNameArguments)
+ groups
+ removeGroup(_ data: RemoveGroupArguments)
+ getElementsForGroup(_ data: GetElementsForGroupArguments)

##PluginMethodChannel
+ getPlatformVersion
+ createMeshManagerApi

##DoozProvisionedMeshNodeChannel
+ unicastAddress
+ nodeName(_ data: NodeNameArguments)
+ name
+ elements
+ elementAt

##DoozUnprovisionedMeshNodeChannel
+ getNumberOfElements

#import "NordicNrfMeshPlugin.h"
#if __has_include(<nordic_nrf_mesh/nordic_nrf_mesh-Swift.h>)
#import <nordic_nrf_mesh/nordic_nrf_mesh-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nordic_nrf_mesh-Swift.h"
#endif

@implementation NordicNrfMeshPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNordicNrfMeshPlugin registerWithRegistrar:registrar];
}
@end

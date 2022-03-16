#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nordic_nrf_mesh.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nordic_nrf_mesh'
  s.version          = '0.10.0'
  s.summary          = 'A Flutter plugin to enable mesh network management and communication using Nordic SDKs. It also provides the ability to open BLE connection with mesh nodes using some other Flutter plugin.'
  s.description      = <<-DESC
A Flutter plugin to enable mesh network management and communication using Nordic SDKs. It also provides the ability to open BLE connection with mesh nodes using some other Flutter plugin.
                       DESC
  s.homepage         = 'http://dooz-domotique.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OZEO-DOOZ' => 'contact@dooz-domotique.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'nRFMeshProvision'

  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end

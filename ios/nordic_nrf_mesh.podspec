#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nordic_nrf_mesh.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nordic_nrf_mesh'
  s.version          = '0.13.0'
  s.summary          = 'A Flutter plugin to enable mesh network management and communication using Nordic Semiconductor SDKs.'
  s.description      = <<-DESC
A Flutter plugin to enable mesh network management and communication using Nordic Semiconductor SDKs.
                       DESC
  s.homepage         = 'http://dooz-domotique.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'OZEO-DOOZ' => 'contact@dooz-domotique.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'nRFMeshProvision'

  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

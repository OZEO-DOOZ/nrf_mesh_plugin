import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

void main() {
  const channel = MethodChannel('fr.dooz.nordic_nrf_mesh/methods');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await NordicNrfMesh().platformVersion, '42');
  });
}

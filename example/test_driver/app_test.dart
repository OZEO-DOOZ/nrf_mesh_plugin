import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:pedantic/pedantic.dart';

void main() {
  FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      unawaited(driver.close());
    }
  });

  test('go to provisioning page', () async {
    final provisioningItemFinder = find.text('Provisioning');
    await driver.tap(provisioningItemFinder);
  });

  test('launch provisioning on the first item', () async {
    final firstDeviceFinder = find.byValueKey('device-0');
    await driver.tap(firstDeviceFinder);

    final circularLoadingFinder = find.byType('CircularProgressIndicator');
    await driver.waitForAbsent(circularLoadingFinder);
  }, timeout: Timeout(Duration(minutes: 10)));
}

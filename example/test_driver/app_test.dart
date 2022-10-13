import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    unawaited(driver.close());
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
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('see new node in meshNetwork', () async {
    final homeItemFinder = find.text('Home');
    await driver.tap(homeItemFinder);
    final loadItemFinder = find.text('Load MeshNetwork');
    await driver.tap(loadItemFinder);
    final provisionnerWidget = find.byValueKey('node-0');
    await driver.waitFor(provisionnerWidget);
    final newNodeWidget = find.byValueKey('node-1');
    await driver.waitFor(newNodeWidget);
  });

  test('go to control page', () async {
    final controlItemFinder = find.text('Control');
    await driver.tap(controlItemFinder);
    final linearLoadingFinder = find.byType('LinearProgressIndicator');
    await driver.waitForAbsent(linearLoadingFinder);
  });

  test('connect to device', () async {
    final findFirstDevice = find.byValueKey('device-0');
    await driver.tap(findFirstDevice);
    final circularLoadingFinder = find.byType('CircularProgressIndicator');
    await driver.waitForAbsent(circularLoadingFinder);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('open node page to configure and go back', () async {
    final firstNodeFinder = find.byValueKey('node-0');
    await driver.tap(firstNodeFinder);
    final circularLoadingFinder = find.byType('CircularProgressIndicator');
    await driver.waitForAbsent(circularLoadingFinder);
    final configureAsDimmer = find.text('Configure output as light dimmer');
    await driver.tap(configureAsDimmer);
    await driver.waitFor(find.text('Board successfully configured'));
    final backPage = find.pageBack();
    await driver.tap(backPage);
  }, timeout: const Timeout(Duration(minutes: 1)));

  test('turn first light on', () async {
    final sendGenericLevelFinder = find.text('Send a generic level set');
    await driver.tap(sendGenericLevelFinder);
    final elementAddressInput = find.byValueKey('module-send-generic-level-address');
    await driver.tap(elementAddressInput);
    await driver.enterText('3');

    final elementValueInput = find.byValueKey('module-send-generic-level-value');
    await driver.tap(elementValueInput);
    await driver.enterText('32767');

    await driver.tap(find.text('Send level'));
    await driver.waitFor(find.text('OK'));
  }, timeout: const Timeout(Duration(minutes: 1)));

  test('turn first light off', () async {
    final sendGenericOnOffFinder = find.text('Send a generic On Off set');
    await driver.tap(sendGenericOnOffFinder);
    final elementAddressInput = find.byValueKey('module-send-generic-on-off-address');
    await driver.tap(elementAddressInput);
    await driver.enterText('3');
    await driver.tap(find.text('Send on off'));
    await driver.waitFor(find.text('OK'));
  }, timeout: const Timeout(Duration(minutes: 1)));
}

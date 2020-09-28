import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  final targetOs = arguments.isNotEmpty && arguments.first == 'ios' ? Platform.isIOS : Platform.isAndroid;

  if (targetOs == Platform.isAndroid) {
    if (!Platform.environment.containsKey('ANDROID_SDK_ROOT')) {
      throw 'Please setup ANDROID_SDK_ROOT env variable';
    }

    print('building app');
    await Process.run(
      'flutter',
      [
        'build',
        'apk',
        '--debug',
        '-t',
        'test_driver/app.dart',
      ],
    );
    print('installing app');
    await Process.run('flutter', ['install']);
    final adbPath = '${Platform.environment['ANDROID_SDK_ROOT']}/platform-tools/adb';
    var baseCommand = [
      '-d',
      'shell',
      'pm',
      'grant',
      'fr.dooz.nordic_nrf_mesh_example',
    ];

    //  setup permission
    var accessCoarseLocation = [...baseCommand, 'android.permission.ACCESS_COARSE_LOCATION'];
    await Process.run(
      adbPath,
      accessCoarseLocation,
      runInShell: true,
    );
    var accessFineLocation = [...baseCommand, 'android.permission.ACCESS_FINE_LOCATION'];
    await Process.run(
      adbPath,
      accessFineLocation,
      runInShell: true,
    );
  } else {
    //  TODO: add building app for ios

    print('installing app');
    await Process.run('flutter', ['install']);

    //  TODO: add simutils to approve
  }

  print('launch driver');
  final flutterDriveProcess = await Process.start('flutter', ['drive', '--target=test_driver/app.dart', '--no-build']);
  flutterDriveProcess.stdout.transform(utf8.decoder).listen(stdout.write);
  await flutterDriveProcess.exitCode;
}

import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  final targetOs = arguments.isNotEmpty && arguments.first == 'ios' ? Platform.isIOS : Platform.isAndroid;

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

  if (targetOs == Platform.isAndroid) {
    if (!Platform.environment.containsKey('ANDROID_SDK_ROOT')) {
      throw 'Please setup ANDROID_SDK_ROOT env variable';
    }
    final adbPath = '${Platform.environment['ANDROID_SDK_ROOT']}/platform-tools/adb';
    print('installing app and accept all permissions');
    await Process.run(adbPath, ['install -g build/app/outputs/apk/debug/app-debug.apk']);
  } else {
    print('installing app');
    await Process.run('flutter', ['install']);

    //  TODO: add simutils to approve
  }

  print('launch driver');
  final flutterDriveProcess = await Process.start('flutter', ['drive', '--target=test_driver/app.dart', '--no-build']);
  flutterDriveProcess.stdout.transform(utf8.decoder).listen(stdout.write);
  await flutterDriveProcess.exitCode;
}

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pedantic/pedantic.dart';

import 'package:nordic_nrf_mesh_example/src/app.dart';

void main() async {
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  unawaited(runZonedGuarded<Future<void>>(
    () async {
      runApp(MyApp());
    },
    FirebaseCrashlytics.instance.recordError,
  ));
}

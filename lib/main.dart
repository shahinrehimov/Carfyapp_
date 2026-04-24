import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/data/models/translation/translation_local_model.dart';
import 'package:carfy/firebase_options.dart';
import 'package:carfy/presentation/app/ui/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await _config();

    runApp(const CarfyApp());
    FlutterNativeSplash.remove();
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

Future<void> _config() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Route Flutter framework errors through Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Catch platform/async errors from the Dart isolate.
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Disable collection in debug; keep it on for release/profile.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  await PrefUtil.init();
  await _initLocalStorage();

  GetIt.I.allowReassignment = true;
  configureDependencies();
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
  );
}

Future<void> _initLocalStorage() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TranslationLocalModelAdapter());
}

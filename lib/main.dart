import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'common/di/di.dart';
import 'common/router/app_router.dart';
import 'common/util/pref_util.dart';
import 'presentation/app/ui/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _config();

  runApp(const CarfyApp());
  FlutterNativeSplash.remove();
}

Future<void> _config() async {
  await PrefUtil.init();

  GetIt.I.allowReassignment = true;
  configureDependencies();
  getIt.registerSingleton<AppRouter>(AppRouter());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
  );
}

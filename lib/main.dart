import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'common/di/di.dart';
import 'common/router/app_router.dart';
import 'common/util/pref_util.dart';
import 'presentation/app/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _config();

  runApp(const CarfyApp());
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

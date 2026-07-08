import 'dart:io';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/domain/use_cases/auth/check_logged_use_case.dart';
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart';
import 'package:carfy/domain/use_cases/auth/get_guest_identifier_use_case.dart';
import 'package:carfy/domain/entities/setting/app_setting.dart';
import 'package:carfy/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GenerateGuestIdentifierUseCase _generateGuestIdentifierUseCase;
  final CheckLoggedUseCase _checkLoggedUseCase;
  final GetGuestIdentifierUseCase _getGuestIdentifierUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final AppRouter _appRouter;

  SplashCubit({
    AppRouter? appRouter,
    GenerateGuestIdentifierUseCase? generateGuestIdentifierUseCase,
    CheckLoggedUseCase? checkLoggedUseCase,
    GetGuestIdentifierUseCase? getGuestIdentifierUseCase,
    GetSettingUseCase? getSettingUseCase,
  })  : _appRouter = appRouter ?? getIt<AppRouter>(),
        _generateGuestIdentifierUseCase = generateGuestIdentifierUseCase ?? getIt<GenerateGuestIdentifierUseCase>(),
        _checkLoggedUseCase = checkLoggedUseCase ?? getIt<CheckLoggedUseCase>(),
        _getGuestIdentifierUseCase = getGuestIdentifierUseCase ?? getIt<GetGuestIdentifierUseCase>(),
        _getSettingUseCase = getSettingUseCase ?? getIt<GetSettingUseCase>(),
        super(SplashState.initial());

  Future<void> init() async {
    final settingFuture = _getSettingUseCase();
    final hasAuth = (await _checkLoggedUseCase()).getOrElse(() => false);
    final hasIdentifier = (await _getGuestIdentifierUseCase()).getOrElse(() => null) != null;

    if (!hasAuth && !hasIdentifier) {
      await _generateGuestIdentifierUseCase();
    }

    final settingResult = await settingFuture;
    AppSetting? setting;
    settingResult.fold((_) {}, (s) => setting = s);

    if (setting != null) {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final minVersion = Platform.isIOS ? setting!.iosMinVersion : setting!.androidMinVersion;

      if (_isForceUpdateRequired(currentVersion, minVersion)) {
        FlutterNativeSplash.remove();
        _appRouter.replaceAll([const ForceUpdateRoute()]);
        return;
      }
    }

    _navigateToMain();
  }

  bool _isForceUpdateRequired(String current, String min) {
    try {
      final c = current.split('.').map(int.parse).toList();
      final m = min.split('.').map(int.parse).toList();
      for (int i = 0; i < m.length; i++) {
        final cv = i < c.length ? c[i] : 0;
        final mv = m[i];
        if (cv < mv) return true;
        if (cv > mv) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  void _navigateToMain() {
    FlutterNativeSplash.remove();
    _appRouter.replaceAll([const MainRoute()]);
  }
}

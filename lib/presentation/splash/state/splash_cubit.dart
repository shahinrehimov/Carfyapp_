import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GenerateGuestIdentifierUseCase _generateGuestIdentifierUseCase;
  final AppRouter _appRouter;

  SplashCubit({AppRouter? appRouter, GenerateGuestIdentifierUseCase? generateGuestIdentifierUseCase})
    : _appRouter = appRouter ?? getIt<AppRouter>(),
      _generateGuestIdentifierUseCase = generateGuestIdentifierUseCase ?? getIt<GenerateGuestIdentifierUseCase>(),
      super(SplashState.initial());

  Future<void> init() async {
    final hasAuth = PrefUtil.getString(AppPreferenceKeys.authToken) != null;
    final hasIdentifier = PrefUtil.getString(AppPreferenceKeys.guestIdentifier) != null;

    if (!hasAuth && !hasIdentifier) {
      await _generateGuestIdentifier();
    } else {
      _navigateToMain();
    }
  }

  Future<void> _generateGuestIdentifier() async {
    final result = await _generateGuestIdentifierUseCase();
    result.fold(
      (_) => _navigateToMain(),
      (success) {
        PrefUtil.setString(AppPreferenceKeys.guestIdentifier, success.identifier);
        _navigateToMain();
      },
    );
  }

  void _navigateToMain() {
    FlutterNativeSplash.remove();
    _appRouter.replaceAll([const MainRoute()]);
  }
}

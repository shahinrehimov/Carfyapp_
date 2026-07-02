import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/domain/use_cases/auth/check_logged_use_case.dart';
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart';
import 'package:carfy/domain/use_cases/auth/get_guest_identifier_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GenerateGuestIdentifierUseCase _generateGuestIdentifierUseCase;
  final CheckLoggedUseCase _checkLoggedUseCase;
  final GetGuestIdentifierUseCase _getGuestIdentifierUseCase;
  final AppRouter _appRouter;

  SplashCubit({
    AppRouter? appRouter,
    GenerateGuestIdentifierUseCase? generateGuestIdentifierUseCase,
    CheckLoggedUseCase? checkLoggedUseCase,
    GetGuestIdentifierUseCase? getGuestIdentifierUseCase,
  })  : _appRouter = appRouter ?? getIt<AppRouter>(),
        _generateGuestIdentifierUseCase = generateGuestIdentifierUseCase ?? getIt<GenerateGuestIdentifierUseCase>(),
        _checkLoggedUseCase = checkLoggedUseCase ?? getIt<CheckLoggedUseCase>(),
        _getGuestIdentifierUseCase = getGuestIdentifierUseCase ?? getIt<GetGuestIdentifierUseCase>(),
        super(SplashState.initial());

  Future<void> init() async {
    final hasAuth = (await _checkLoggedUseCase()).getOrElse(() => false);
    final hasIdentifier = (await _getGuestIdentifierUseCase()).getOrElse(() => null) != null;

    if (!hasAuth && !hasIdentifier) {
      await _generateGuestIdentifierUseCase();
    }
    _navigateToMain();
  }

  void _navigateToMain() {
    FlutterNativeSplash.remove();
    _appRouter.replaceAll([const MainRoute()]);
  }
}

import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/error/failure.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GenerateGuestIdentifierUseCase _generateGuestIdentifierUseCase;
  final AppRouter _appRouter;

  SplashCubit({AppRouter? appRouter, GenerateGuestIdentifierUseCase? generateGuestIdentifierUseCase})
    : _appRouter = appRouter ?? getIt<AppRouter>(),
      _generateGuestIdentifierUseCase = generateGuestIdentifierUseCase ?? getIt<GenerateGuestIdentifierUseCase>(),
      super(SplashState.initial());

  void init() {
    _checkFirstEnter();
  }

  Future<void> _checkFirstEnter() async {
    final bool firstEnter = PrefUtil.getBool(AppPreferenceKeys.firstEnter) ?? true;
    emit(state.copyWith(firstEnter: firstEnter));
    PrefUtil.setBool(AppPreferenceKeys.firstEnter, false);
    await Future.delayed(const Duration(milliseconds: 300));

    if (!firstEnter) {
      final hasAuth = PrefUtil.getString(AppPreferenceKeys.authToken) != null;
      final hasIdentifier = PrefUtil.getString(AppPreferenceKeys.guestIdentifier) != null;
      if (!hasAuth && !hasIdentifier) {
        generateGuestIdentifier();
      } else {
        _appRouter.replaceAll([const MainRoute()]);
      }
    }
  }

  void generateGuestIdentifier() async {
    emit(state.copyWith(guestIdentifierState: StateStatus.loading()));
    final result = await _generateGuestIdentifierUseCase();
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.networkFailure()));
        } else if (failure is ServerFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.serverFailure()));
        } else if (failure is UserFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.failure(failure.message)));
        }
      },
      (success) {
        PrefUtil.setString(AppPreferenceKeys.guestIdentifier, success.identifier);
        _appRouter.replaceAll([const MainRoute()]);
      },
    );
  }
}

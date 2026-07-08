import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/use_cases/auth/apple_native_login_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'social_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> with StateMapHelper {
  final AppleNativeLoginUseCase _appleNativeLoginUseCase;
  final AppRouter _appRouter;

  SocialLoginCubit({
    AppleNativeLoginUseCase? appleNativeLoginUseCase,
    AppRouter? appRouter,
  }) : _appleNativeLoginUseCase = appleNativeLoginUseCase ?? getIt<AppleNativeLoginUseCase>(),
       _appRouter = appRouter ?? getIt<AppRouter>(),
       super(SocialLoginState.initial());

  Future<void> loginWithApple() async {
    try {
      emit(state.copyWith(appleStatus: StateStatus.loading()));

      final result = await _appleNativeLoginUseCase();

      result.fold(
        (failure) => emit(state.copyWith(appleStatus: mapFailure(failure))),
        (_) {
          emit(state.copyWith(appleStatus: StateStatus.success()));
          _appRouter.pushAndPopUntil(const MainRoute(), predicate: (_) => false);
        },
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      emit(state.copyWith(appleStatus: StateStatus.initial()));
      if (e.code == AuthorizationErrorCode.canceled) return;
      emit(state.copyWith(appleStatus: StateStatus.failure(e.message)));
    } catch (_) {
      emit(state.copyWith(appleStatus: StateStatus.serverFailure()));
    }
  }
}

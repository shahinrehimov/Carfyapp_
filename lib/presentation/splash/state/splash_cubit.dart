import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppRouter _appRouter;

  SplashCubit({AppRouter? appRouter}) : _appRouter = appRouter ?? getIt<AppRouter>(), super(SplashState.initial());

  void init() {
    _checkFirstEnter();
  }

  void _checkFirstEnter() {
    final bool firstEnter = PrefUtil.getBool(AppPreferenceKeys.firstEnter) ?? true;
    emit(state.copyWith(firstEnter: firstEnter));
    PrefUtil.setBool(AppPreferenceKeys.firstEnter, false);

    if (!firstEnter) {
      Future.microtask(() {
        _appRouter.pushAndPopUntil(MainRoute(), predicate: (_) => false);
      });
    }
  }
}

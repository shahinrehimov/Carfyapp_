import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/use_cases/auth/check_logged_use_case.dart';
import 'package:carfy/domain/use_cases/auth/get_profile_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with StateMapHelper {
  final GetProfileUseCase _getProfileUseCase;
  final CheckLoggedUseCase _checkLoggedUseCase;

  ProfileCubit({GetProfileUseCase? getProfileUseCase, CheckLoggedUseCase? checkLoggedUseCase})
    : _getProfileUseCase = getProfileUseCase ?? getIt<GetProfileUseCase>(),
      _checkLoggedUseCase = checkLoggedUseCase ?? getIt<CheckLoggedUseCase>(),
      super(ProfileState.initial());

  Future<void> init() async {
    await _checkAuthenticated();
  }

  Future<void> _checkAuthenticated() async {
    final result = await _checkLoggedUseCase();
    final authenticated = result.getOrElse(() => false);
    emit(state.copyWith(authenticated: authenticated));
    if (authenticated) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    emit(state.copyWith(status: StateStatus.loading()));

    final result = await _getProfileUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(status: mapFailure(failure)));
      },
      (user) {
        emit(state.copyWith(status: StateStatus.success(), user: user));
      },
    );
  }
}

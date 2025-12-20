import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/use_cases/auth/get_profile_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with StateMapHelper {
  final GetProfileUseCase _getProfileUseCase;

  ProfileCubit({GetProfileUseCase? getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase ?? getIt<GetProfileUseCase>(),
      super(ProfileState.initial());

  Future<void> init() async {
    _checkAuthenticated();
    await _loadProfile();
  }

  void _checkAuthenticated() {
    final bool authenticated = PrefUtil.getBool(AppPreferenceKeys.authToken) != null;
    emit(state.copyWith(authenticated: authenticated));
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

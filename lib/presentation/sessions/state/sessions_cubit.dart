import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/entities/auth/session.dart';
import 'package:carfy/domain/use_cases/auth/get_sessions_use_case.dart';
import 'package:carfy/domain/use_cases/auth/logout_session_use_case.dart';
import 'package:carfy/domain/use_cases/auth/logout_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> with StateMapHelper {
  final GetSessionsUseCase _getSessionsUseCase;
  final LogoutSessionUseCase _logoutSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  SessionsCubit({
    GetSessionsUseCase? getSessionsUseCase,
    LogoutSessionUseCase? logoutSessionUseCase,
    LogoutUseCase? logoutUseCase,
  })  : _getSessionsUseCase = getSessionsUseCase ?? getIt<GetSessionsUseCase>(),
        _logoutSessionUseCase = logoutSessionUseCase ?? getIt<LogoutSessionUseCase>(),
        _logoutUseCase = logoutUseCase ?? getIt<LogoutUseCase>(),
        super(SessionsState.initial());

  Future<void> init() => _loadSessions();

  Future<void> _loadSessions() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getSessionsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) => emit(state.copyWith(
        status: StateStatus.success(),
        currentSession: response.currentSession,
        otherSessions: response.otherSessions,
      )),
    );
  }

  Future<void> logoutCurrentSession() async {
    emit(state.copyWith(logoutStatus: StateStatus.loading()));
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(logoutStatus: mapFailure(failure))),
      (_) {
        PrefUtil.remove(AppPreferenceKeys.authToken);
        PrefUtil.remove(AppPreferenceKeys.guestIdentifier);
        emit(state.copyWith(logoutStatus: StateStatus.success()));
      },
    );
  }

  Future<void> terminateSession(int tokenId) async {
    emit(state.copyWith(terminateStatus: {...state.terminateStatus, tokenId: StateStatus.loading()}));
    final result = await _logoutSessionUseCase(tokenId);
    result.fold(
      (failure) {
        final updated = {...state.terminateStatus}..remove(tokenId);
        emit(state.copyWith(terminateStatus: updated, status: mapFailure(failure)));
      },
      (message) {
        final updated = {...state.terminateStatus}..remove(tokenId);
        final others = state.otherSessions.where((s) => s.id != tokenId).toList();
        emit(state.copyWith(
          terminateStatus: updated,
          otherSessions: others,
          status: StateStatus.successWithMessage(message),
        ));
      },
    );
  }
}

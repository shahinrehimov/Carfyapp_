part of 'sessions_cubit.dart';

class SessionsState extends Equatable {
  final StateStatus status;
  final StateStatus logoutStatus;
  final Session? currentSession;
  final List<Session> otherSessions;
  final Map<int, StateStatus> terminateStatus;

  const SessionsState({
    required this.status,
    required this.logoutStatus,
    this.currentSession,
    required this.otherSessions,
    required this.terminateStatus,
  });

  factory SessionsState.initial() => SessionsState(
    status: StateStatus.initial(),
    logoutStatus: StateStatus.initial(),
    currentSession: null,
    otherSessions: [],
    terminateStatus: {},
  );

  SessionsState copyWith({
    StateStatus? status,
    StateStatus? logoutStatus,
    Session? currentSession,
    List<Session>? otherSessions,
    Map<int, StateStatus>? terminateStatus,
  }) {
    return SessionsState(
      status: status ?? this.status,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      currentSession: currentSession ?? this.currentSession,
      otherSessions: otherSessions ?? this.otherSessions,
      terminateStatus: terminateStatus ?? this.terminateStatus,
    );
  }

  @override
  List<Object?> get props => [status, logoutStatus, currentSession, otherSessions, terminateStatus];
}

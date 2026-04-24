import 'package:carfy/domain/entities/auth/session.dart';

class SessionsResponse {
  final Session currentSession;
  final List<Session> otherSessions;

  const SessionsResponse({required this.currentSession, required this.otherSessions});
}

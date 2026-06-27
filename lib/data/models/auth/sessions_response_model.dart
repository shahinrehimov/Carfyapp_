import 'package:carfy/data/models/auth/session_model.dart';

class SessionsResponseModel {
  final SessionModel currentSession;
  final List<SessionModel> otherSessions;

  SessionsResponseModel({required this.currentSession, required this.otherSessions});

  factory SessionsResponseModel.fromJson(Map<String, dynamic> json) => SessionsResponseModel(
    currentSession: SessionModel.fromJson(json['current_session']),
    otherSessions: (json['other_sessions'] as List? ?? []).map((e) => SessionModel.fromJson(e)).toList(),
  );
}

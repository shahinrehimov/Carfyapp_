part of 'social_login_cubit.dart';

class SocialLoginState extends Equatable {
  final StateStatus appleStatus;
  final StateStatus googleStatus;

  const SocialLoginState({required this.appleStatus, required this.googleStatus});

  factory SocialLoginState.initial() => SocialLoginState(
    appleStatus: StateStatus.initial(),
    googleStatus: StateStatus.initial(),
  );

  SocialLoginState copyWith({StateStatus? appleStatus, StateStatus? googleStatus}) {
    return SocialLoginState(
      appleStatus: appleStatus ?? this.appleStatus,
      googleStatus: googleStatus ?? this.googleStatus,
    );
  }

  @override
  List<Object?> get props => [appleStatus, googleStatus];
}

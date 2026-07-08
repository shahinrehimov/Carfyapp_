part of 'social_login_cubit.dart';

class SocialLoginState extends Equatable {
  final StateStatus appleStatus;

  const SocialLoginState({required this.appleStatus});

  factory SocialLoginState.initial() => SocialLoginState(appleStatus: StateStatus.initial());

  SocialLoginState copyWith({StateStatus? appleStatus}) {
    return SocialLoginState(appleStatus: appleStatus ?? this.appleStatus);
  }

  @override
  List<Object?> get props => [appleStatus];
}

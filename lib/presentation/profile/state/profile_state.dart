part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final bool authenticated;
  final StateStatus status;
  final AuthUser? user;

  const ProfileState({required this.status, required this.authenticated, this.user});

  factory ProfileState.initial() => ProfileState(authenticated: true, status: StateStatus.initial());

  ProfileState copyWith({StateStatus? status, AuthUser? user, bool? authenticated}) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      authenticated: authenticated ?? this.authenticated,
    );
  }

  @override
  List<Object?> get props => [status, user];
}

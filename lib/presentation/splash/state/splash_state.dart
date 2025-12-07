part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final bool firstEnter;
  final StateStatus guestIdentifierState;

  const SplashState({required this.firstEnter, required this.guestIdentifierState});

  factory SplashState.initial() => SplashState(firstEnter: false, guestIdentifierState: StateStatus.initial());

  SplashState copyWith({bool? firstEnter, StateStatus? guestIdentifierState}) {
    return SplashState(
      firstEnter: firstEnter ?? this.firstEnter,
      guestIdentifierState: guestIdentifierState ?? this.guestIdentifierState,
    );
  }

  @override
  List<Object?> get props => [firstEnter, guestIdentifierState];
}

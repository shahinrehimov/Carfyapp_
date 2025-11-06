part of 'splash_cubit.dart';

class SplashState extends Equatable {
  final bool firstEnter;

  const SplashState({required this.firstEnter});

  factory SplashState.initial() => const SplashState(firstEnter: false);

  SplashState copyWith({bool? firstEnter}) {
    return SplashState(firstEnter: firstEnter ?? this.firstEnter);
  }

  @override
  List<Object?> get props => [];
}

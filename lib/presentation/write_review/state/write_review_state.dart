part of 'write_review_cubit.dart';

class WriteReviewState extends Equatable {
  final StateStatus submitStatus;
  final AuthUser? user;
  final FieldValidationState ratingValidationState;
  final FieldValidationState nameValidationState;
  final FieldValidationState surnameValidationState;
  final FieldValidationState emailValidationState;
  final FieldValidationState reviewValidationState;
  final FieldValidationState imagesValidationState;

  const WriteReviewState({
    required this.submitStatus,
    this.user,
    required this.ratingValidationState,
    required this.nameValidationState,
    required this.surnameValidationState,
    required this.emailValidationState,
    required this.reviewValidationState,
    required this.imagesValidationState,
  });

  factory WriteReviewState.initial() => WriteReviewState(
        submitStatus: StateStatus.initial(),
        ratingValidationState: FieldValidationState.pure(),
        nameValidationState: FieldValidationState.pure(),
        surnameValidationState: FieldValidationState.pure(),
        emailValidationState: FieldValidationState.pure(),
        reviewValidationState: FieldValidationState.pure(),
        imagesValidationState: FieldValidationState.pure(),
      );

  WriteReviewState copyWith({
    StateStatus? submitStatus,
    AuthUser? user,
    FieldValidationState? ratingValidationState,
    FieldValidationState? nameValidationState,
    FieldValidationState? surnameValidationState,
    FieldValidationState? emailValidationState,
    FieldValidationState? reviewValidationState,
    FieldValidationState? imagesValidationState,
  }) =>
      WriteReviewState(
        submitStatus: submitStatus ?? this.submitStatus,
        user: user ?? this.user,
        ratingValidationState: ratingValidationState ?? this.ratingValidationState,
        nameValidationState: nameValidationState ?? this.nameValidationState,
        surnameValidationState: surnameValidationState ?? this.surnameValidationState,
        emailValidationState: emailValidationState ?? this.emailValidationState,
        reviewValidationState: reviewValidationState ?? this.reviewValidationState,
        imagesValidationState: imagesValidationState ?? this.imagesValidationState,
      );

  @override
  List<Object?> get props => [
        submitStatus,
        user,
        ratingValidationState,
        nameValidationState,
        surnameValidationState,
        emailValidationState,
        reviewValidationState,
        imagesValidationState,
      ];
}

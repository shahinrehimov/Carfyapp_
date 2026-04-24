part of 'contact_us_cubit.dart';

class ContactUsState extends Equatable {
  final StateStatus submitStatus;
  final AuthUser? user;
  final FieldValidationState messageValidationState;

  const ContactUsState({
    required this.submitStatus,
    this.user,
    required this.messageValidationState,
  });

  factory ContactUsState.initial() => ContactUsState(
    submitStatus: StateStatus.initial(),
    messageValidationState: FieldValidationState.pure(),
  );

  ContactUsState copyWith({
    StateStatus? submitStatus,
    AuthUser? user,
    FieldValidationState? messageValidationState,
  }) => ContactUsState(
    submitStatus: submitStatus ?? this.submitStatus,
    user: user ?? this.user,
    messageValidationState: messageValidationState ?? this.messageValidationState,
  );

  @override
  List<Object?> get props => [submitStatus, user, messageValidationState];
}

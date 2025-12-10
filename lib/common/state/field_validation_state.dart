class FieldValidationState {
  const FieldValidationState();

  factory FieldValidationState.pure() = FieldValidationPure;

  factory FieldValidationState.failure(String msg) = FieldValidationFailure;
}

class FieldValidationPure extends FieldValidationState {
  FieldValidationPure();
}

class FieldValidationFailure extends FieldValidationState {
  final String msg;

  FieldValidationFailure(this.msg);
}

extension FieldValidationStateX on FieldValidationState {
  String? get message {
    if (this is FieldValidationFailure) {
      return (this as FieldValidationFailure).msg;
    }
    return null;
  }
}

class FieldValidationState {
  const FieldValidationState();

  factory FieldValidationState.pure() = FieldValidationPure;

  factory FieldValidationState.valid() = FieldValidationValid;

  factory FieldValidationState.required() = FieldValidationRequired;

  factory FieldValidationState.short() = FieldValidationShort;

  factory FieldValidationState.tooLong() = FieldValidationTooLong;

  factory FieldValidationState.regex() = FieldValidationRegex;

  factory FieldValidationState.invalidEmail() = FieldValidationInvalidEmail;

  T maybeWhen<T>({
    T Function()? pure,
    T Function()? valid,
    T Function()? requiredField,
    T Function()? short,
    T Function()? tooLong,
    T Function()? invalidEmail,
    T Function()? regex,
    required T Function() orElse,
  }) {
    if (this is FieldValidationPure && pure != null) return pure();
    if (this is FieldValidationValid && valid != null) return valid();
    if (this is FieldValidationRequired && requiredField != null) return requiredField();
    if (this is FieldValidationShort && short != null) return short();
    if (this is FieldValidationTooLong && tooLong != null) return tooLong();
    if (this is FieldValidationInvalidEmail && invalidEmail != null) return invalidEmail();
    if (this is FieldValidationRegex && regex != null) return regex();
    return orElse();
  }
}

class FieldValidationPure extends FieldValidationState {
  FieldValidationPure();
}

class FieldValidationValid extends FieldValidationState {
  FieldValidationValid();
}

class FieldValidationRequired extends FieldValidationState {
  FieldValidationRequired();
}

class FieldValidationShort extends FieldValidationState {
  FieldValidationShort();
}

class FieldValidationTooLong extends FieldValidationState {
  FieldValidationTooLong();
}

class FieldValidationInvalidEmail extends FieldValidationState {
  FieldValidationInvalidEmail();
}

class FieldValidationRegex extends FieldValidationState {
  FieldValidationRegex();
}

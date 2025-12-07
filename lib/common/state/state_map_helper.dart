import 'package:carfy/common/state/state_status.dart';

import '../error/failure.dart';
import 'field_validation_state.dart';

mixin StateMapHelper {
  StateStatus mapFailure(Failure failure) {
    if (failure is ConnectionFailure) {
      return StateStatus.networkFailure();
    } else if (failure is ServerFailure) {
      return StateStatus.serverFailure();
    } else if (failure is UserFailure) {
      return StateStatus.failure(failure.message);
    }
    return StateStatus.initial();
  }

  FieldValidationState mapValidationFailure(String key, ValidationFailure failure) {
    final errors = ((failure.errors[key] ?? []) as List);
    if (errors.isNotEmpty) {
      final error = errors.first;
      if (error == 'validation.required') {
        return FieldValidationState.required();
      } else if (error == 'validation.email') {
        return FieldValidationState.invalidEmail();
      } else if (error == 'validation.size.string') {
        return FieldValidationState.short();
      } else if (error == 'validation.regex') {
        return FieldValidationState.regex();
      }
    }
    return FieldValidationState.pure();
  }
}

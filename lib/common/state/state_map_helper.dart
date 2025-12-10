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
    final errors = (failure.errors[key] ?? []) as List;

    if (errors.isEmpty) {
      return FieldValidationState.pure();
    }

    // Single error → return as plain text
    if (errors.length == 1) {
      return FieldValidationState.failure(errors.first);
    }

    // Multiple errors → return numbered list
    final message = errors.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');

    return FieldValidationState.failure(message);
  }
}

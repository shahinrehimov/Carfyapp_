import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/params/contact/send_contact_params.dart';
import 'package:carfy/domain/use_cases/auth/get_profile_use_case.dart';
import 'package:carfy/domain/use_cases/contact/send_contact_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> with StateMapHelper {
  final SendContactUseCase _sendContactUseCase;
  final GetProfileUseCase _getProfileUseCase;

  ContactUsCubit({
    SendContactUseCase? sendContactUseCase,
    GetProfileUseCase? getProfileUseCase,
  }) : _sendContactUseCase = sendContactUseCase ?? getIt<SendContactUseCase>(),
       _getProfileUseCase = getProfileUseCase ?? getIt<GetProfileUseCase>(),
       super(ContactUsState.initial());

  Future<void> init() async {
    final result = await _getProfileUseCase();
    result.fold((_) {}, (user) => emit(state.copyWith(user: user)));
  }

  Future<void> submit({required String message, required String successMessage}) async {
    final user = state.user;
    if (user == null) return;

    emit(state.copyWith(
      submitStatus: StateStatus.loading(),
      messageValidationState: FieldValidationState.pure(),
    ));

    final result = await _sendContactUseCase(SendContactParams(
      fullName: user.fullName,
      email: user.email,
      message: message,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(submitStatus: mapFailure(failure)));
        if (failure is ValidationFailure) _emitValidationErrors(failure);
      },
      (_) => emit(state.copyWith(submitStatus: StateStatus.successWithMessage(successMessage))),
    );
  }

  void _emitValidationErrors(ValidationFailure failure) {
    emit(state.copyWith(
      messageValidationState: mapValidationFailure('message', failure),
    ));
  }
}

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/params/auth/update_profile_params.dart';
import 'dart:io';

import 'package:carfy/domain/use_cases/auth/delete_account_use_case.dart';
import 'package:carfy/domain/use_cases/auth/delete_profile_image_use_case.dart';
import 'package:carfy/domain/use_cases/auth/logout_use_case.dart';
import 'package:carfy/domain/use_cases/auth/update_profile_image_use_case.dart';
import 'package:carfy/domain/use_cases/auth/update_profile_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> with StateMapHelper {
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final DeleteProfileImageUseCase _deleteProfileImageUseCase;

  ProfileUpdateCubit({
    UpdateProfileUseCase? updateProfileUseCase,
    LogoutUseCase? logoutUseCase,
    DeleteAccountUseCase? deleteAccountUseCase,
    UpdateProfileImageUseCase? updateProfileImageUseCase,
    DeleteProfileImageUseCase? deleteProfileImageUseCase,
  }) : _updateProfileUseCase = updateProfileUseCase ?? getIt<UpdateProfileUseCase>(),
       _logoutUseCase = logoutUseCase ?? getIt<LogoutUseCase>(),
       _deleteAccountUseCase = deleteAccountUseCase ?? getIt<DeleteAccountUseCase>(),
       _updateProfileImageUseCase = updateProfileImageUseCase ?? getIt<UpdateProfileImageUseCase>(),
       _deleteProfileImageUseCase = deleteProfileImageUseCase ?? getIt<DeleteProfileImageUseCase>(),
       super(ProfileUpdateState.initial());

  void init(AuthUser user) {
    // Normalize birthDate: API returns yyyy-MM-dd, convert to dd.MM.yyyy
    final birthDate = _normalizeBirthDate(user.birthDate);
    emit(
      state.copyWith(
        name: user.name,
        surname: user.surname,
        selectedGender: user.gender,
        birthDate: birthDate,
        initialName: user.name,
        initialSurname: user.surname,
        initialGender: user.gender,
        initialBirthDate: birthDate,
        currentImageUrl: user.image,
        email: user.email,
        phone: user.phone,
        registerType: user.registerType,
      ),
    );
  }

  void updateContact(AuthUser user) {
    emit(
      state.copyWith(
        email: user.email,
        phone: user.phone,
        updatedUser: user,
      ),
    );
  }

  String? _normalizeBirthDate(String? raw) {
    if (raw == null) return null;
    if (raw.contains('.')) return raw;
    final parts = raw.split('-');
    if (parts.length == 3) return '${parts[2]}.${parts[1]}.${parts[0]}';
    return raw;
  }

  void setName(String v) => emit(state.copyWith(name: v, clearNameError: true));
  void setSurname(String v) => emit(state.copyWith(surname: v, clearSurnameError: true));
  void selectGender(String gender) => emit(state.copyWith(selectedGender: gender));
  void setBirthDate(String? date) => emit(state.copyWith(birthDate: date, clearBirthDate: date == null));

  Future<void> save() async {
    final hasName = state.name.trim().isNotEmpty;
    final hasSurname = state.surname.trim().isNotEmpty;

    emit(
      state.copyWith(
        nameError: hasName ? null : ProfileUpdateFieldError.required,
        clearNameError: hasName,
        surnameError: hasSurname ? null : ProfileUpdateFieldError.required,
        clearSurnameError: hasSurname,
      ),
    );

    if (!hasName || !hasSurname) return;

    emit(state.copyWith(submitStatus: StateStatus.loading()));

    final params = UpdateProfileParams(
      name: state.name.trim(),
      surname: state.surname.trim(),
      gender: state.selectedGender,
      birthDate: state.birthDate,
    );

    final result = await _updateProfileUseCase(params);
    result.fold(
      (failure) {
        emit(state.copyWith(submitStatus: mapFailure(failure)));
        if (failure is ValidationFailure) _emitValidationErrors(failure);
      },
      (user) {
        final birthDate = _normalizeBirthDate(user.birthDate);
        emit(
          state.copyWith(
            submitStatus: StateStatus.success(),
            name: user.name,
            surname: user.surname,
            selectedGender: user.gender,
            birthDate: birthDate,
            initialName: user.name,
            initialSurname: user.surname,
            initialGender: user.gender,
            initialBirthDate: birthDate,
            updatedUser: user,
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutStatus: StateStatus.loading()));
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(logoutStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(logoutStatus: StateStatus.success())),
    );
  }

  Future<void> updateProfileImage(File image) async {
    emit(state.copyWith(imageStatus: StateStatus.loading()));
    final result = await _updateProfileImageUseCase(image);
    result.fold(
      (failure) => emit(state.copyWith(imageStatus: mapFailure(failure))),
      (user) => emit(state.copyWith(imageStatus: StateStatus.success(), currentImageUrl: user.image)),
    );
  }

  Future<void> deleteProfileImage() async {
    emit(state.copyWith(imageStatus: StateStatus.loading()));
    final result = await _deleteProfileImageUseCase();
    result.fold(
      (failure) => emit(state.copyWith(imageStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(imageStatus: StateStatus.success(), clearCurrentImageUrl: true)),
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(deleteStatus: StateStatus.loading()));
    final result = await _deleteAccountUseCase();
    result.fold(
      (failure) => emit(state.copyWith(deleteStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(deleteStatus: StateStatus.success())),
    );
  }

  void _emitValidationErrors(ValidationFailure failure) {
    emit(
      state.copyWith(
        nameValidationError: failure.errors['name']?.firstOrNull,
        surnameValidationError: failure.errors['surname']?.firstOrNull,
        genderValidationError: failure.errors['gender']?.firstOrNull,
        birthDateValidationError: failure.errors['birth_date']?.firstOrNull,
      ),
    );
  }
}

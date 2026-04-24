import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/params/product/store_review_params.dart';
import 'package:carfy/domain/use_cases/auth/get_profile_use_case.dart';
import 'package:carfy/domain/use_cases/product/store_review_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'write_review_state.dart';

class WriteReviewCubit extends Cubit<WriteReviewState> with StateMapHelper {
  final StoreReviewUseCase _storeReviewUseCase;
  final GetProfileUseCase _getProfileUseCase;

  WriteReviewCubit({
    StoreReviewUseCase? storeReviewUseCase,
    GetProfileUseCase? getProfileUseCase,
  })  : _storeReviewUseCase = storeReviewUseCase ?? getIt<StoreReviewUseCase>(),
        _getProfileUseCase = getProfileUseCase ?? getIt<GetProfileUseCase>(),
        super(WriteReviewState.initial());

  bool get isGuest => PrefUtil.getString(AppPreferenceKeys.authToken) == null;

  Future<void> init() async {
    if (isGuest) return;
    final result = await _getProfileUseCase();
    result.fold(
      (_) {},
      (user) => emit(state.copyWith(user: user)),
    );
  }

  Future<void> submit({
    required String cpvUuid,
    required int rating,
    required String name,
    required String surname,
    required String email,
    required String review,
    required List<String> imagePaths,
    required String successMessage,
  }) async {
    emit(state.copyWith(
      submitStatus: StateStatus.loading(),
      ratingValidationState: FieldValidationState.pure(),
      nameValidationState: FieldValidationState.pure(),
      surnameValidationState: FieldValidationState.pure(),
      emailValidationState: FieldValidationState.pure(),
      reviewValidationState: FieldValidationState.pure(),
      imagesValidationState: FieldValidationState.pure(),
    ));
    final result = await _storeReviewUseCase(StoreReviewParams(
      cpvUuid: cpvUuid,
      rating: rating,
      name: name,
      surname: surname,
      email: email,
      review: review,
      imagePaths: imagePaths,
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
      ratingValidationState: mapValidationFailure('rating', failure),
      nameValidationState: mapValidationFailure('name', failure),
      surnameValidationState: mapValidationFailure('surname', failure),
      emailValidationState: mapValidationFailure('email', failure),
      reviewValidationState: mapValidationFailure('review', failure),
      imagesValidationState: mapValidationFailure('images', failure),
    ));
  }
}

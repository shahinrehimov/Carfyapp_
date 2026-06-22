import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/translation/app_language.dart';
import 'package:carfy/domain/use_cases/translations/get_languages_list_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_picker_state.dart';

class LanguagePickerCubit extends Cubit<LanguagePickerState> with StateMapHelper {
  final GetLanguagesListUseCase _getLanguagesListUseCase;

  LanguagePickerCubit({GetLanguagesListUseCase? getLanguagesListUseCase})
      : _getLanguagesListUseCase = getLanguagesListUseCase ?? getIt<GetLanguagesListUseCase>(),
        super(LanguagePickerState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getLanguagesListUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (languages) => emit(state.copyWith(
        status: languages.isEmpty ? StateStatus.empty() : StateStatus.success(),
        languages: languages,
      )),
    );
  }
}

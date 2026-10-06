import 'dart:async';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/search_suggestions.dart';
import 'package:carfy/domain/use_cases/search/get_search_suggestions_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_suggestions_state.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> with StateMapHelper {
  final GetSearchSuggestionsUseCase _useCase;
  Timer? _debounce;

  SearchSuggestionsCubit({GetSearchSuggestionsUseCase? useCase})
      : _useCase = useCase ?? getIt<GetSearchSuggestionsUseCase>(),
        super(SearchSuggestionsState.initial());

  void onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      emit(SearchSuggestionsState.initial());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetch(query.trim()));
  }

  Future<void> _fetch(String query) async {
    if (isClosed) return;
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _useCase(query);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (suggestions) => emit(state.copyWith(status: StateStatus.success(), suggestions: suggestions)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

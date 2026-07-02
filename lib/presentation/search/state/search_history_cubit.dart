import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/use_cases/search/add_search_history_use_case.dart';
import 'package:carfy/domain/use_cases/search/clear_search_history_use_case.dart';
import 'package:carfy/domain/use_cases/search/get_search_history_use_case.dart';
import 'package:carfy/domain/use_cases/search/remove_search_history_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> with StateMapHelper {
  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final AddSearchHistoryUseCase _addSearchHistoryUseCase;
  final RemoveSearchHistoryUseCase _removeSearchHistoryUseCase;
  final ClearSearchHistoryUseCase _clearSearchHistoryUseCase;

  SearchHistoryCubit({
    GetSearchHistoryUseCase? getSearchHistoryUseCase,
    AddSearchHistoryUseCase? addSearchHistoryUseCase,
    RemoveSearchHistoryUseCase? removeSearchHistoryUseCase,
    ClearSearchHistoryUseCase? clearSearchHistoryUseCase,
  })  : _getSearchHistoryUseCase = getSearchHistoryUseCase ?? getIt<GetSearchHistoryUseCase>(),
        _addSearchHistoryUseCase = addSearchHistoryUseCase ?? getIt<AddSearchHistoryUseCase>(),
        _removeSearchHistoryUseCase = removeSearchHistoryUseCase ?? getIt<RemoveSearchHistoryUseCase>(),
        _clearSearchHistoryUseCase = clearSearchHistoryUseCase ?? getIt<ClearSearchHistoryUseCase>(),
        super(SearchHistoryState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getSearchHistoryUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (history) => emit(state.copyWith(status: StateStatus.success(), history: history)),
    );
  }

  Future<void> add(String query) async {
    await _addSearchHistoryUseCase(query);
    await load();
  }

  Future<void> remove(String query) async {
    await _removeSearchHistoryUseCase(query);
    await load();
  }

  Future<void> clear() async {
    await _clearSearchHistoryUseCase();
    await load();
  }
}

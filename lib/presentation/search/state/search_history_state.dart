part of 'search_history_cubit.dart';

class SearchHistoryState extends Equatable {
  final StateStatus status;
  final List<String> history;

  const SearchHistoryState({required this.status, this.history = const []});

  factory SearchHistoryState.initial() => SearchHistoryState(status: StateStatus.initial());

  SearchHistoryState copyWith({StateStatus? status, List<String>? history}) {
    return SearchHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [status, history];
}

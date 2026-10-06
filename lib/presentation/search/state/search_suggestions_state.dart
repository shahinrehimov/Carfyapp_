part of 'search_suggestions_cubit.dart';

class SearchSuggestionsState extends Equatable {
  final StateStatus status;
  final SearchSuggestions? suggestions;

  const SearchSuggestionsState({required this.status, this.suggestions});

  factory SearchSuggestionsState.initial() =>
      SearchSuggestionsState(status: StateStatus.initial());

  SearchSuggestionsState copyWith({StateStatus? status, SearchSuggestions? suggestions}) {
    return SearchSuggestionsState(
      status: status ?? this.status,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  bool get hasSuggestions =>
      suggestions != null &&
      (suggestions!.products.isNotEmpty || suggestions!.categories.isNotEmpty);

  @override
  List<Object?> get props => [status, suggestions];
}

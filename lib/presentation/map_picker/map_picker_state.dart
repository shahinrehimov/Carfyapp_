part of 'map_picker_cubit.dart';

class NominatimResult {
  final String displayName;
  final double lat;
  final double lng;

  const NominatimResult({required this.displayName, required this.lat, required this.lng});
}

class MapPickerState extends Equatable {
  final LatLng position;
  final List<NominatimResult> searchResults;
  final bool isSearching;
  final bool isLocating;
  final LatLng? moveToPosition;

  const MapPickerState({
    required this.position,
    this.searchResults = const [],
    this.isSearching = false,
    this.isLocating = false,
    this.moveToPosition,
  });

  MapPickerState copyWith({
    LatLng? position,
    List<NominatimResult>? searchResults,
    bool? isSearching,
    bool? isLocating,
    LatLng? moveToPosition,
    bool clearSearchResults = false,
    bool clearMoveToPosition = false,
  }) =>
      MapPickerState(
        position: position ?? this.position,
        searchResults: clearSearchResults ? [] : (searchResults ?? this.searchResults),
        isSearching: isSearching ?? this.isSearching,
        isLocating: isLocating ?? this.isLocating,
        moveToPosition: clearMoveToPosition ? null : (moveToPosition ?? this.moveToPosition),
      );

  @override
  List<Object?> get props => [position, searchResults, isSearching, isLocating, moveToPosition];
}

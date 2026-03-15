import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'map_picker_state.dart';

class MapPickerCubit extends Cubit<MapPickerState> {
  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
  Timer? _debounce;
  CancelToken? _cancelToken;

  MapPickerCubit({LatLng? initial})
      : super(MapPickerState(
          position: initial ?? const LatLng(40.4093, 49.8671),
        ));

  void updatePosition(LatLng position) => emit(state.copyWith(position: position));

  void searchPlaces(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(state.copyWith(isSearching: false, clearSearchResults: true));
      return;
    }
    emit(state.copyWith(isSearching: true));
    _debounce = Timer(const Duration(milliseconds: 600), () => _doSearch(query));
  }

  Future<void> _doSearch(String query) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    try {
      final pos = state.position;
      final response = await _dio.get(
        'https://photon.komoot.io/api/',
        queryParameters: {
          'q': query,
          'limit': 7,
          'lat': pos.latitude,
          'lon': pos.longitude,
          'lang': 'en',
        },
        options: Options(headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; CarfyApp/1.0)',
          'Accept': 'application/json',
        }),
        cancelToken: _cancelToken,
      );
      final features = response.data['features'] as List;
      final results = features.map((item) {
        final props = item['properties'] as Map<String, dynamic>;
        final coords = item['geometry']['coordinates'] as List;
        final parts = [
          props['name'],
          props['street'],
          props['district'],
          props['city'],
          props['state'],
        ].whereType<String>().where((s) => s.isNotEmpty).toSet().join(', ');
        return NominatimResult(
          displayName: parts.isNotEmpty ? parts : query,
          lat: (coords[1] as num).toDouble(),
          lng: (coords[0] as num).toDouble(),
        );
      }).toList();
      emit(state.copyWith(isSearching: false, searchResults: results));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(state.copyWith(isSearching: false, clearSearchResults: true));
    } catch (_) {
      emit(state.copyWith(isSearching: false, clearSearchResults: true));
    }
  }

  void clearSearch() => emit(state.copyWith(clearSearchResults: true));

  void selectSearchResult(NominatimResult result) {
    emit(state.copyWith(
      position: LatLng(result.lat, result.lng),
      moveToPosition: LatLng(result.lat, result.lng),
      clearSearchResults: true,
    ));
  }

  void onMapMoved() {
    if (state.moveToPosition != null) {
      emit(state.copyWith(clearMoveToPosition: true));
    }
  }

  Future<void> goToCurrentLocation() async {
    emit(state.copyWith(isLocating: true));
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(state.copyWith(isLocating: false));
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      emit(state.copyWith(
        position: latLng,
        moveToPosition: latLng,
        isLocating: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLocating: false));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _cancelToken?.cancel();
    _dio.close();
    return super.close();
  }
}

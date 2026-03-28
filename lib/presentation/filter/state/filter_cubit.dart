import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/city.dart';
import 'package:carfy/domain/entities/products/brand_model_item.dart';
import 'package:carfy/domain/entities/products/filter_brand.dart';
import 'package:carfy/domain/entities/products/filter_option.dart';
import 'package:carfy/domain/entities/products/product_filters.dart';
import 'package:carfy/domain/use_cases/product/get_product_filters_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> with StateMapHelper {
  final GetProductFiltersUseCase _getProductFiltersUseCase;
  FilterState? _snapshot;

  FilterCubit({GetProductFiltersUseCase? getProductFiltersUseCase})
      : _getProductFiltersUseCase = getProductFiltersUseCase ?? getIt<GetProductFiltersUseCase>(),
        super(FilterState.initial());

  Future<void> loadFilters() async {
    if (state.filtersData != null) return;
    emit(state.copyWith(loadStatus: StateStatus.loading()));
    final result = await _getProductFiltersUseCase();
    result.fold(
      (failure) => emit(state.copyWith(loadStatus: mapFailure(failure))),
      (filters) => emit(state.copyWith(loadStatus: StateStatus.success(), filtersData: filters)),
    );
  }

  /// Call when bottom sheet opens — saves current state so we can restore on dismiss
  void saveSnapshot() {
    _snapshot = state;
  }

  /// Call when bottom sheet is dismissed without apply — restores saved state
  void restoreSnapshot() {
    if (_snapshot != null) {
      emit(_snapshot!);
      _snapshot = null;
    }
  }

  /// Call when user taps apply — clears snapshot so current state becomes the applied state
  void apply() {
    _snapshot = null;
  }

  void selectBrand(FilterBrand? brand) {
    emit(state.copyWith(selectedBrand: brand, clearBrand: brand == null, clearModel: true));
  }

  void selectModel(BrandModelItem? model) {
    emit(state.copyWith(selectedModel: model, clearModel: model == null));
  }

  void selectCity(City? city) {
    emit(state.copyWith(selectedCity: city, clearCity: city == null));
  }

  void selectColor(FilterOption? color) {
    emit(state.copyWith(selectedColor: color, clearColor: color == null));
  }

  void selectCondition(FilterOption? condition) {
    emit(state.copyWith(selectedCondition: condition, clearCondition: condition == null));
  }

  void selectMinYear(int? year) {
    emit(state.copyWith(minYear: year, clearMinYear: year == null));
  }

  void selectMaxYear(int? year) {
    emit(state.copyWith(maxYear: year, clearMaxYear: year == null));
  }

  void setMinPrice(String value) {
    emit(state.copyWith(minPrice: value, clearMinPrice: value.isEmpty));
  }

  void setMaxPrice(String value) {
    emit(state.copyWith(maxPrice: value, clearMaxPrice: value.isEmpty));
  }

  void reset() {
    emit(FilterState.initial().copyWith(
      loadStatus: state.loadStatus,
      filtersData: state.filtersData,
    ));
  }

  void restoreApplied(FilterState applied) {
    emit(applied.copyWith(loadStatus: state.loadStatus, filtersData: state.filtersData));
  }
}

part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final StateStatus loadStatus;
  final ProductFilters? filtersData;
  final FilterBrand? selectedBrand;
  final BrandModelItem? selectedModel;
  final City? selectedCity;
  final FilterOption? selectedColor;
  final FilterOption? selectedCondition;
  final Set<String> selectedCategories;
  final Set<String> selectedSubCategories;
  final int? minYear;
  final int? maxYear;
  final String? minPrice;
  final String? maxPrice;

  const FilterState({
    required this.loadStatus,
    this.filtersData,
    this.selectedBrand,
    this.selectedModel,
    this.selectedCity,
    this.selectedColor,
    this.selectedCondition,
    this.selectedCategories = const {},
    this.selectedSubCategories = const {},
    this.minYear,
    this.maxYear,
    this.minPrice,
    this.maxPrice,
  });

  factory FilterState.initial() => FilterState(loadStatus: StateStatus.initial());

  int get selectedCategoryCount => selectedCategories.length + selectedSubCategories.length;

  bool get hasActiveFilters =>
      selectedBrand != null ||
      selectedModel != null ||
      selectedCity != null ||
      selectedColor != null ||
      selectedCondition != null ||
      selectedCategories.isNotEmpty ||
      selectedSubCategories.isNotEmpty ||
      minYear != null ||
      maxYear != null ||
      (minPrice != null && minPrice!.isNotEmpty) ||
      (maxPrice != null && maxPrice!.isNotEmpty);

  FilterState copyWith({
    StateStatus? loadStatus,
    ProductFilters? filtersData,
    FilterBrand? selectedBrand,
    bool clearBrand = false,
    BrandModelItem? selectedModel,
    bool clearModel = false,
    City? selectedCity,
    bool clearCity = false,
    FilterOption? selectedColor,
    bool clearColor = false,
    FilterOption? selectedCondition,
    bool clearCondition = false,
    Set<String>? selectedCategories,
    Set<String>? selectedSubCategories,
    int? minYear,
    bool clearMinYear = false,
    int? maxYear,
    bool clearMaxYear = false,
    String? minPrice,
    bool clearMinPrice = false,
    String? maxPrice,
    bool clearMaxPrice = false,
  }) {
    return FilterState(
      loadStatus: loadStatus ?? this.loadStatus,
      filtersData: filtersData ?? this.filtersData,
      selectedBrand: clearBrand ? null : (selectedBrand ?? this.selectedBrand),
      selectedModel: clearModel ? null : (selectedModel ?? this.selectedModel),
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      selectedColor: clearColor ? null : (selectedColor ?? this.selectedColor),
      selectedCondition: clearCondition ? null : (selectedCondition ?? this.selectedCondition),
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubCategories: selectedSubCategories ?? this.selectedSubCategories,
      minYear: clearMinYear ? null : (minYear ?? this.minYear),
      maxYear: clearMaxYear ? null : (maxYear ?? this.maxYear),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  @override
  List<Object?> get props => [
    loadStatus, filtersData, selectedBrand, selectedModel, selectedCity,
    selectedColor, selectedCondition, selectedCategories, selectedSubCategories,
    minYear, maxYear, minPrice, maxPrice,
  ];
}

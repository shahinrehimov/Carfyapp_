part of 'category_cubit.dart';

class CategoryState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;
  final Category? selectedCategory;

  const CategoryState({required this.categoriesStatus, required this.categories, this.selectedCategory});

  factory CategoryState.initial() => CategoryState(categoriesStatus: StateStatus.initial(), categories: []);

  static const _undefined = Object();

  CategoryState copyWith({
    StateStatus? categoriesStatus,
    List<Category>? categories,
    Object? selectedCategory = _undefined,
  }) {
    return CategoryState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory == _undefined ? this.selectedCategory : selectedCategory as Category?,
    );
  }

  @override
  List<Object?> get props => [categoriesStatus, categories, selectedCategory];
}

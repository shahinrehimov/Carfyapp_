part of 'home_cubit.dart';

class HomeState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;
  final StateStatus productsStatus;
  final List<Product> products;

  const HomeState({
    required this.categoriesStatus,
    required this.categories,
    required this.productsStatus,
    required this.products,
  });

  factory HomeState.initial() => HomeState(
    categoriesStatus: StateStatus.initial(),
    categories: [],
    productsStatus: StateStatus.initial(),
    products: [],
  );

  HomeState copyWith({
    StateStatus? categoriesStatus,
    List<Category>? categories,
    StateStatus? productsStatus,
    List<Product>? products,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [categoriesStatus, categories, productsStatus, products];
}

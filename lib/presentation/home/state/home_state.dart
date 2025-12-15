part of 'home_cubit.dart';

class HomeState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;
  final StateStatus productsStatus;
  final List<Product> products;
  final StateStatus bestSellerStatus;
  final Group? bestSeller;

  const HomeState({
    required this.categoriesStatus,
    required this.categories,
    required this.productsStatus,
    required this.products,
    required this.bestSellerStatus,
    this.bestSeller,
  });

  factory HomeState.initial() => HomeState(
    categoriesStatus: StateStatus.initial(),
    categories: [],
    productsStatus: StateStatus.initial(),
    products: [],
    bestSellerStatus: StateStatus.initial(),
    bestSeller: null,
  );

  HomeState copyWith({
    StateStatus? categoriesStatus,
    List<Category>? categories,
    StateStatus? productsStatus,
    List<Product>? products,
    StateStatus? bestSellerStatus,
    Group? bestSeller,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      bestSellerStatus: bestSellerStatus ?? this.bestSellerStatus,
      bestSeller: bestSeller ?? this.bestSeller,
    );
  }

  @override
  List<Object?> get props => [categoriesStatus, categories, productsStatus, products, bestSellerStatus, bestSeller];
}

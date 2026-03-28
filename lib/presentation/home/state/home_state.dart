part of 'home_cubit.dart';

class HomeState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;
  final StateStatus productsStatus;
  final List<Product> products;
  final StateStatus groupsStatus;
  final List<Group> groups;

  const HomeState({
    required this.categoriesStatus,
    required this.categories,
    required this.productsStatus,
    required this.products,
    required this.groupsStatus,
    required this.groups,
  });

  factory HomeState.initial() => HomeState(
    categoriesStatus: StateStatus.loading(),
    categories: [],
    productsStatus: StateStatus.loading(),
    products: [],
    groupsStatus: StateStatus.loading(),
    groups: [],
  );

  HomeState copyWith({
    StateStatus? categoriesStatus,
    List<Category>? categories,
    StateStatus? productsStatus,
    List<Product>? products,
    StateStatus? groupsStatus,
    List<Group>? groups,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      groupsStatus: groupsStatus ?? this.groupsStatus,
      groups: groups ?? this.groups,
    );
  }

  @override
  List<Object?> get props => [categoriesStatus, categories, productsStatus, products, groupsStatus, groups];
}

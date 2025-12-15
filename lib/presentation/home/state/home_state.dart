part of 'home_cubit.dart';

class HomeState extends Equatable {
  final StateStatus categoriesStatus;
  final List<Category> categories;

  const HomeState({required this.categoriesStatus, required this.categories});

  factory HomeState.initial() => HomeState(categoriesStatus: StateStatus.initial(), categories: []);

  HomeState copyWith({StateStatus? categoriesStatus, List<Category>? categories}) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [categoriesStatus, categories];
}

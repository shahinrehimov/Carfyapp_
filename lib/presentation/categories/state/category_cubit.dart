import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/domain/use_cases/category/get_categories_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> with StateMapHelper {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryCubit({GetCategoriesUseCase? getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase ?? getIt<GetCategoriesUseCase>(),
      super(CategoryState.initial());

  Future<void> init() async {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(categoriesStatus: StateStatus.loading()));
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(categoriesStatus: mapFailure(failure)));
      },
      (categories) {
        emit(state.copyWith(categoriesStatus: StateStatus.success(), categories: categories));
      },
    );
  }
}

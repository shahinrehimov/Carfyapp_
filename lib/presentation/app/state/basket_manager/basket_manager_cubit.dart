import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/use_cases/basket/add_to_basket_use_case.dart';
import 'package:carfy/domain/use_cases/basket/decrement_quantity_use_case.dart';
import 'package:carfy/domain/use_cases/basket/increment_quantity_use_case.dart';
import 'package:carfy/domain/use_cases/basket/remove_from_basket_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'basket_manager_state.dart';

class BasketManagerCubit extends Cubit<BasketManagerState> with StateMapHelper {
  final AddToBasketUseCase _addToBasketUseCase;
  final RemoveFromBasketUseCase _removeFromBasketUseCase;
  final IncrementQuantityUseCase _incrementQuantityUseCase;
  final DecrementQuantityUseCase _decrementQuantityUseCase;

  BasketManagerCubit({
    AddToBasketUseCase? addToBasketUseCase,
    RemoveFromBasketUseCase? removeFromBasketUseCase,
    IncrementQuantityUseCase? incrementQuantityUseCase,
    DecrementQuantityUseCase? decrementQuantityUseCase,
  })  : _addToBasketUseCase = addToBasketUseCase ?? getIt<AddToBasketUseCase>(),
        _removeFromBasketUseCase = removeFromBasketUseCase ?? getIt<RemoveFromBasketUseCase>(),
        _incrementQuantityUseCase = incrementQuantityUseCase ?? getIt<IncrementQuantityUseCase>(),
        _decrementQuantityUseCase = decrementQuantityUseCase ?? getIt<DecrementQuantityUseCase>(),
        super(BasketManagerState.initial());

  Future<void> addToBasket(int productId) async {
    _setProductState(productId, StateStatus.loading());
    final result = await _addToBasketUseCase(productId);
    result.fold(
      (failure) {
        _setProductState(productId, mapFailure(failure));
      },
      (response) {
        _setProductState(productId, StateStatus.successWithMessage(response.message));
        _setBasketActionStatus(StateStatus.success());
      },
    );
  }

  Future<void> removeFromBasket(int productId) async {
    _setBasketActionStatus(StateStatus.loading());

    final result = await _removeFromBasketUseCase(productId);
    result.fold(
      (failure) {
        _setBasketActionStatus(mapFailure(failure));
      },
      (response) {
        _setBasketActionStatus(StateStatus.successWithMessage(response.message));
      },
    );
  }

  Future<void> incrementQuantity(int productId) async {
    _setBasketActionStatus(StateStatus.loading());

    final result = await _incrementQuantityUseCase(productId);
    result.fold(
      (failure) {
        _setBasketActionStatus(mapFailure(failure));
      },
      (response) {
        _setBasketActionStatus(StateStatus.successWithMessage(response.message));
      },
    );
  }

  Future<void> decrementQuantity(int productId) async {
    _setBasketActionStatus(StateStatus.loading());

    final result = await _decrementQuantityUseCase(productId);
    result.fold(
      (failure) {
        _setBasketActionStatus(mapFailure(failure));
      },
      (response) {
        _setBasketActionStatus(StateStatus.successWithMessage(response.message));
      },
    );
  }

  void _setProductState(int productId, StateStatus status) {
    final updatedStates = Map<int, StateStatus>.from(state.productLoadingStates);
    updatedStates[productId] = status;
    emit(state.copyWith(productLoadingStates: updatedStates));
  }

  void _setBasketActionStatus(StateStatus status) {
    emit(state.copyWith(basketActionStatus: status));
  }

  void clearProductState(int productId) {
    final updatedStates = Map<int, StateStatus>.from(state.productLoadingStates);
    updatedStates.remove(productId);
    emit(state.copyWith(productLoadingStates: updatedStates));
  }

  void clearBasketActionStatus() {
    emit(state.copyWith(basketActionStatus: StateStatus.initial()));
  }
}

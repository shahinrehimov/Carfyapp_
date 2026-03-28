import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/basket/basket_data.dart';
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

  Future<void> addToBasket(String cpvUuid) async {
    _setProductState(cpvUuid, StateStatus.loading());
    final result = await _addToBasketUseCase(cpvUuid);
    result.fold(
      (failure) {
        _setProductState(cpvUuid, mapFailure(failure));
      },
      (response) {
        _setProductState(cpvUuid, StateStatus.successWithMessage(response.message));
        _setBasketActionStatus(StateStatus.success());
      },
    );
  }

  Future<void> removeFromBasket(String cpvUuid) async {
    _setProductState(cpvUuid, StateStatus.loading());

    final result = await _removeFromBasketUseCase(cpvUuid);
    result.fold(
      (failure) {
        _setProductState(cpvUuid, mapFailure(failure));
      },
      (response) {
        _setProductState(cpvUuid, StateStatus.success());
        _emitQuantityUpdate(cpvUuid, 0, response.basketData);
      },
    );
  }

  Future<void> incrementQuantity(String cpvUuid) async {
    _setProductState(cpvUuid, StateStatus.loading());

    final result = await _incrementQuantityUseCase(cpvUuid);
    result.fold(
      (failure) {
        _setProductState(cpvUuid, mapFailure(failure));
      },
      (response) {
        _setProductState(cpvUuid, StateStatus.success());
        _emitQuantityUpdate(cpvUuid, response.quantity, response.basketData);
      },
    );
  }

  Future<void> decrementQuantity(String cpvUuid) async {
    _setProductState(cpvUuid, StateStatus.loading());

    final result = await _decrementQuantityUseCase(cpvUuid);
    result.fold(
      (failure) {
        _setProductState(cpvUuid, mapFailure(failure));
      },
      (response) {
        _setProductState(cpvUuid, StateStatus.success());
        _emitQuantityUpdate(cpvUuid, response.quantity, response.basketData);
      },
    );
  }

  void _emitQuantityUpdate(String cpvUuid, int quantity, BasketData basketData) {
    emit(state.copyWith(
      quantityUpdate: QuantityUpdate(cpvUuid: cpvUuid, quantity: quantity, basketData: basketData),
    ));
  }

  void _setProductState(String cpvUuid, StateStatus status) {
    final updatedStates = Map<String, StateStatus>.from(state.productLoadingStates);
    updatedStates[cpvUuid] = status;
    emit(state.copyWith(productLoadingStates: updatedStates));
  }

  void _setBasketActionStatus(StateStatus status) {
    emit(state.copyWith(basketActionStatus: status));
  }

  void clearProductState(String cpvUuid) {
    final updatedStates = Map<String, StateStatus>.from(state.productLoadingStates);
    updatedStates.remove(cpvUuid);
    emit(state.copyWith(productLoadingStates: updatedStates));
  }

  void clearProductStates(List<String> cpvUuids) {
    final updatedStates = Map<String, StateStatus>.from(state.productLoadingStates);
    for (final uuid in cpvUuids) {
      updatedStates.remove(uuid);
    }
    emit(state.copyWith(productLoadingStates: updatedStates));
  }

  void clearBasketActionStatus() {
    emit(state.copyWith(basketActionStatus: StateStatus.initial()));
  }
}

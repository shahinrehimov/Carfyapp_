import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/basket/basket_data.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';
import 'package:carfy/domain/use_cases/basket/get_basket_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'basket_state.dart';

class BasketCubit extends Cubit<BasketState> with StateMapHelper {
  final GetBasketUseCase _getBasketUseCase;
  List<BasketProduct>? _snapshotItems;
  BasketData? _snapshotBasketData;

  BasketCubit({GetBasketUseCase? getBasketUseCase})
    : _getBasketUseCase = getBasketUseCase ?? getIt<GetBasketUseCase>(),
      super(BasketState.initial());

  Future<void> init() async {
    _loadBasket();
  }

  Future<void> _loadBasket() async {
    emit(state.copyWith(basketStatus: StateStatus.loading()));

    final result = await _getBasketUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(basketStatus: mapFailure(failure)));
      },
      (response) {
        emit(
          state.copyWith(basketStatus: StateStatus.success(), items: response.items, basketData: response.basketData),
        );
      },
    );
  }

  Future<void> refresh() async {
    await _loadBasket();
  }

  void _saveSnapshot() {
    _snapshotItems = List.from(state.items);
    _snapshotBasketData = state.basketData;
  }

  void rollback() {
    if (_snapshotItems != null) {
      emit(state.copyWith(items: _snapshotItems!, basketData: _snapshotBasketData));
      _snapshotItems = null;
      _snapshotBasketData = null;
    }
  }

  void optimisticIncrement(String cpvUuid) {
    _saveSnapshot();
    final updatedItems = state.items.map((item) {
      if (item.product.seller?.uuid == cpvUuid) {
        final newQty = item.basketQuantity + 1;
        return BasketProduct(
          product: item.product,
          basketQuantity: newQty,
          priceInBasket: item.product.price * newQty,
          priceFinalInBasket: item.product.priceFinal * newQty,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems, basketData: _recalculateBasketData(updatedItems)));
  }

  void optimisticDecrement(String cpvUuid) {
    _saveSnapshot();
    final item = state.items.firstWhere(
      (item) => item.product.seller?.uuid == cpvUuid,
      orElse: () => state.items.first,
    );
    if (item.basketQuantity <= 1) return;

    final updatedItems = state.items.map((item) {
      if (item.product.seller?.uuid == cpvUuid) {
        final newQty = item.basketQuantity - 1;
        return BasketProduct(
          product: item.product,
          basketQuantity: newQty,
          priceInBasket: item.product.price * newQty,
          priceFinalInBasket: item.product.priceFinal * newQty,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems, basketData: _recalculateBasketData(updatedItems)));
  }

  void optimisticRemove(String cpvUuid) {
    _saveSnapshot();
    final updatedItems = state.items.where((item) => item.product.seller?.uuid != cpvUuid).toList();
    emit(state.copyWith(items: updatedItems, basketData: _recalculateBasketData(updatedItems)));
  }

  BasketData _recalculateBasketData(List<BasketProduct> items) {
    double totalPrice = 0;
    double totalPriceFinal = 0;
    int totalItems = 0;
    for (final item in items) {
      totalPrice += item.priceInBasket;
      totalPriceFinal += item.priceFinalInBasket;
      totalItems += item.basketQuantity;
    }
    return BasketData(
      totalPrice: totalPrice,
      totalPriceFinal: totalPriceFinal,
      totalDiscount: totalPrice - totalPriceFinal,
      shipping: state.basketData?.shipping ?? 0,
      totalItems: totalItems,
    );
  }

  void updateItemQuantity(String cpvUuid, int newQuantity, BasketData newBasketData) {
    if (newQuantity <= 0) {
      final updatedItems = state.items.where((item) => item.product.seller?.uuid != cpvUuid).toList();
      emit(state.copyWith(items: updatedItems, basketData: newBasketData));
      return;
    }
    final updatedItems = state.items.map((item) {
      if (item.product.seller?.uuid == cpvUuid) {
        return BasketProduct(
          product: item.product,
          basketQuantity: newQuantity,
          priceInBasket: item.product.price * newQuantity,
          priceFinalInBasket: item.product.priceFinal * newQuantity,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems, basketData: newBasketData));
  }

  void removeItem(String cpvUuid, BasketData newBasketData) {
    final updatedItems = state.items.where((item) => item.product.seller?.uuid != cpvUuid).toList();
    emit(state.copyWith(items: updatedItems, basketData: newBasketData));
  }

  void setActionStatus(StateStatus status) {
    emit(state.copyWith(basketActionStatus: status));
  }

  void clearActionStatus() {
    emit(state.copyWith(basketActionStatus: StateStatus.initial()));
  }
}

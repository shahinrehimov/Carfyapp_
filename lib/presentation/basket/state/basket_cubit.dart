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
}

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/use_cases/car/delete_car_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_cars_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_cars_state.dart';

class MyCarsCubit extends Cubit<MyCarsState> with StateMapHelper {
  final GetCarsUseCase _getCarsUseCase;
  final DeleteCarUseCase _deleteCarUseCase;

  MyCarsCubit({GetCarsUseCase? getCarsUseCase, DeleteCarUseCase? deleteCarUseCase})
    : _getCarsUseCase = getCarsUseCase ?? getIt<GetCarsUseCase>(),
      _deleteCarUseCase = deleteCarUseCase ?? getIt<DeleteCarUseCase>(),
      super(MyCarsState.initial());

  Future<void> init() => _loadCars();

  Future<void> refresh() => _loadCars();

  Future<void> _loadCars() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getCarsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) => emit(state.copyWith(status: StateStatus.success(), cars: response.cars)),
    );
  }

  Future<void> deleteCar(int id) async {
    emit(state.copyWith(deleteStatus: {...state.deleteStatus, id: StateStatus.loading()}));
    final result = await _deleteCarUseCase(id);
    result.fold(
      (failure) {
        final updated = {...state.deleteStatus}..remove(id);
        emit(state.copyWith(deleteStatus: updated, status: mapFailure(failure)));
      },
      (message) {
        final updated = {...state.deleteStatus}..remove(id);
        final cars = state.cars.where((c) => c.id != id).toList();
        emit(state.copyWith(deleteStatus: updated, cars: cars, status: StateStatus.successWithMessage(message)));
      },
    );
  }
}

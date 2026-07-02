import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/use_cases/car/get_cars_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_picker_state.dart';

class CarPickerCubit extends Cubit<CarPickerState> with StateMapHelper {
  final GetCarsUseCase _getCarsUseCase;

  CarPickerCubit({GetCarsUseCase? getCarsUseCase})
      : _getCarsUseCase = getCarsUseCase ?? getIt<GetCarsUseCase>(),
        super(CarPickerState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getCarsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) => emit(state.copyWith(status: StateStatus.success(), cars: response.cars)),
    );
  }
}

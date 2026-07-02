part of 'car_picker_cubit.dart';

class CarPickerState extends Equatable {
  final StateStatus status;
  final List<UserCar> cars;

  const CarPickerState({required this.status, this.cars = const []});

  factory CarPickerState.initial() => CarPickerState(status: StateStatus.initial());

  CarPickerState copyWith({StateStatus? status, List<UserCar>? cars}) {
    return CarPickerState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
    );
  }

  @override
  List<Object?> get props => [status, cars];
}

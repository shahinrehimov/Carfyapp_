part of 'my_cars_cubit.dart';

class MyCarsState extends Equatable {
  final StateStatus status;
  final List<UserCar> cars;
  final Map<int, StateStatus> deleteStatus;

  const MyCarsState({required this.status, required this.cars, required this.deleteStatus});

  factory MyCarsState.initial() => MyCarsState(status: StateStatus.loading(), cars: const [], deleteStatus: const {});

  MyCarsState copyWith({StateStatus? status, List<UserCar>? cars, Map<int, StateStatus>? deleteStatus}) {
    return MyCarsState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [status, cars, deleteStatus];
}

part of 'my_addresses_cubit.dart';

class MyAddressesState extends Equatable {
  final StateStatus status;
  final List<Address> addresses;
  final Map<int, StateStatus> deleteStatus;
  final Map<int, StateStatus> setDefaultStatus;

  const MyAddressesState({
    required this.status,
    required this.addresses,
    required this.deleteStatus,
    required this.setDefaultStatus,
  });

  factory MyAddressesState.initial() =>
      MyAddressesState(status: StateStatusLoading(), addresses: [], deleteStatus: {}, setDefaultStatus: {});

  MyAddressesState copyWith({
    StateStatus? status,
    List<Address>? addresses,
    Map<int, StateStatus>? deleteStatus,
    Map<int, StateStatus>? setDefaultStatus,
  }) => MyAddressesState(
    status: status ?? this.status,
    addresses: addresses ?? this.addresses,
    deleteStatus: deleteStatus ?? this.deleteStatus,
    setDefaultStatus: setDefaultStatus ?? this.setDefaultStatus,
  );

  @override
  List<Object?> get props => [status, addresses, deleteStatus, setDefaultStatus];
}

part of 'default_address_cubit.dart';

class DefaultAddressState extends Equatable {
  final Address? address;

  const DefaultAddressState({this.address});

  @override
  List<Object?> get props => [address];
}

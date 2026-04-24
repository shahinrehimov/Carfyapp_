part of 'ads_cubit.dart';

class AdsState extends Equatable {
  final StateStatus status;
  final List<Advertisement> ads;

  const AdsState({required this.status, required this.ads});

  factory AdsState.initial() => AdsState(status: StateStatus.loading(), ads: []);

  AdsState copyWith({StateStatus? status, List<Advertisement>? ads}) {
    return AdsState(status: status ?? this.status, ads: ads ?? this.ads);
  }

  @override
  List<Object?> get props => [status, ads];
}

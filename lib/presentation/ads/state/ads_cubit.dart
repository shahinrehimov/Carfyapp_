import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:carfy/domain/use_cases/advertisements/get_active_advertisements_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> with StateMapHelper {
  final GetActiveAdvertisementsUseCase _getActiveAdvertisementsUseCase;

  AdsCubit({GetActiveAdvertisementsUseCase? getActiveAdvertisementsUseCase})
    : _getActiveAdvertisementsUseCase =
          getActiveAdvertisementsUseCase ?? getIt<GetActiveAdvertisementsUseCase>(),
      super(AdsState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getActiveAdvertisementsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (ads) {
        final visible = ads.where((a) => a.imageUrl != null && a.imageUrl!.isNotEmpty).toList();
        emit(state.copyWith(status: StateStatus.success(), ads: visible));
      },
    );
  }
}

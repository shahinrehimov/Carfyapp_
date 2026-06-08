import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/use_cases/notifications/get_unread_count_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBadgeCubit extends Cubit<int> {
  final GetUnreadCountUseCase _getUnreadCountUseCase;

  NotificationBadgeCubit({GetUnreadCountUseCase? getUnreadCountUseCase})
      : _getUnreadCountUseCase = getUnreadCountUseCase ?? getIt<GetUnreadCountUseCase>(),
        super(0);

  Future<void> load() async {
    final result = await _getUnreadCountUseCase();
    result.fold((_) {}, (count) => emit(count));
  }

  void decrement() {
    if (state > 0) emit(state - 1);
  }

  void clear() => emit(0);
}

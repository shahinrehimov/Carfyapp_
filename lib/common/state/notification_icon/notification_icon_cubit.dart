import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/use_cases/auth/check_logged_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIconCubit extends Cubit<bool> {
  final CheckLoggedUseCase _checkLoggedUseCase;

  NotificationIconCubit({CheckLoggedUseCase? checkLoggedUseCase})
      : _checkLoggedUseCase = checkLoggedUseCase ?? getIt<CheckLoggedUseCase>(),
        super(false);

  Future<void> load() async {
    final result = await _checkLoggedUseCase();
    emit(result.getOrElse(() => false));
  }
}

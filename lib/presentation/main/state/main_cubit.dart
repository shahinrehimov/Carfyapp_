import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/notifications/push_notification_service.dart';
import 'package:carfy/presentation/main/ui/enum/main_pages.dart';

class MainCubit extends Cubit<MainPages> {
  MainCubit() : super(MainPages.home) {
    _initPushNotifications();
  }

  Future<void> _initPushNotifications() async {
    final service = PushNotificationService.instance;
    await service.init();
    await service.requestPermissions();
  }

  void changePage(MainPages page) {
    emit(page);
  }
}

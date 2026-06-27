import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/use_cases/notifications/register_device_token_use_case.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/notifications/push_notification_service.dart';
import 'package:carfy/presentation/main/ui/enum/main_pages.dart';

class MainCubit extends Cubit<MainPages> {
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;

  MainCubit({RegisterDeviceTokenUseCase? registerDeviceTokenUseCase})
    : _registerDeviceTokenUseCase = registerDeviceTokenUseCase ?? getIt<RegisterDeviceTokenUseCase>(),
      super(MainPages.home) {
    _initPushNotifications();
  }

  Future<void> _initPushNotifications() async {
    PushNotificationService().setupInteractedMessage();
    _registerFcmToken();
  }

  Future<void> _registerFcmToken() async {
    final deviceType = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _registerDeviceTokenUseCase(token, deviceType);
    }
  }

  void changePage(MainPages page) {
    emit(page);
  }
}

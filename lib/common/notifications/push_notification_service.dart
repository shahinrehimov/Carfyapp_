import 'package:carfy/common/constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance.requestPermission();
    await _initLocalNotifications();
    await requestPermission();
    _enableIOSNotifications();
    _registerNotificationListeners();
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {},
    );

    final channel = _androidNotificationChannel();
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<bool> requestPermission() async {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

    try {
      if (isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } else {
        await _localNotifications
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true, critical: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

  void _registerNotificationListeners() {
    debugPrint('FCM: listener registered');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM: MESSAGE RECEIVED: ${message.data}');
      debugPrint('FCM: notification: ${message.notification?.title} - ${message.notification?.body}');
      if (defaultTargetPlatform == TargetPlatform.android) {
        _showNotification(message);
      }
    });
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final channel = _androidNotificationChannel();
    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          priority: Priority.max,
          importance: Importance.max,
          playSound: true,
          fullScreenIntent: true,
          enableVibration: true,
        ),
      ),
    );
  }

  Future<void> _enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel _androidNotificationChannel() => const AndroidNotificationChannel(
    Constants.androidNotificationChannelId,
    Constants.androidNotificationChannelName,
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );
}

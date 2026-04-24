import 'package:carfy/common/constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level so Firebase can invoke it after the process is killed.
/// Must be annotated as a VM entry-point; runs in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this minimal — runs in a separate isolate without DI / app state.
  // System tray notifications for data-only messages are handled by OS / FCM.
}

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    Constants.androidNotificationChannelId,
    Constants.androidNotificationChannelName,
    description: Constants.androidNotificationChannelDescription,
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  bool _initialized = false;
  bool _permissionRequested = false;

  /// Wires up handlers and channels without prompting the user. Safe to call
  /// on app start — the OS permission dialog is deferred to
  /// [requestPermissions], which should be called from the main cubit after
  /// the user has landed on the main screen.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _configureForegroundPresentation();
    _registerListeners();
    await _handleLaunchMessage();
  }

  /// Prompts the OS-level notification permission dialog. Call from the
  /// main cubit once the app is in a state where interrupting with a
  /// permission prompt makes sense. Safe to call multiple times — we only
  /// prompt once per process.
  Future<void> requestPermissions() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _configureForegroundPresentation() async {
    // iOS shows foreground pushes natively; Android we handle ourselves via
    // flutter_local_notifications below. Enable iOS native display so we
    // don't double-show on that platform.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _registerListeners() {
    // Foreground message — iOS is handled by the OS; only show on Android.
    FirebaseMessaging.onMessage.listen((message) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        _showLocalNotification(message);
      }
    });

    // Tap on a push while app is backgrounded.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  /// Handles the case where a push opened the app from a terminated state.
  Future<void> _handleLaunchMessage() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _handleMessageOpened(initial);
  }

  // ─────────────────────────── display / tap ───────────────────────────

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
        ),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    // Handle in-app navigation here when you wire up deep links.
    // response.payload contains the message.data map as a string.
  }

  void _handleMessageOpened(RemoteMessage message) {
    // Handle in-app navigation here when you wire up deep links.
    // message.data holds the custom payload from your backend.
  }

  // ─────────────────────────── public helpers ───────────────────────────

  Future<String?> getToken() => FirebaseMessaging.instance.getToken();

  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh;

  Future<void> subscribeToTopic(String topic) => FirebaseMessaging.instance.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) => FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}

// core/notification/notification_service.dart
// ignore_for_file: avoid_print
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/core/extensions/weather_format_extension.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS için bildirim ayarları
    // const IOSInitializationSettings iosInitializationSettings =
    //     IOSInitializationSettings(
    //   requestSoundPermission: true,
    //   requestBadgePermission: true,
    //   requestAlertPermission: true,
    // );
    // Genel ayarlar
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      //iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //onSelectNotification: onSelectNotification,
    );

    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android 13 ve üstü için izin iste
    if (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ==
        true) {
      print('✅ Bildirim izni verildi');
    } else {
      print('❌ Bildirim izni reddedildi');
    }
  }

  Future<bool> isNotificationPermissionGranted() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<void> onSelectNotification(String? payload) async {
    print("Notification Tapped, payload: $payload");
  }

  Future<void> showWeatherNotification({
    required double temperature,
    required String weatherStatus,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      showWhen: false,
    );
    // iOS bildirim detayları
    // const IOSNotificationDetails iosDetails = IOSNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      //iOS: iosDetails,
    );

    const String title = 'Weather Update';
    final String body =
        'Temperature: ${temperature.toCelsiusString}°C, Status: $weatherStatus';

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'weather_payload',
    );
  }
}

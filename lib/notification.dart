import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/match.dart';

enum NotificationType {
  forDemand, // Ihtiyaci olan
  forSource // Ilan ekleyen
}

class NotificationManager {
  static NotificationManager instance = NotificationManager();

  late BuildContext context;

  final AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('app_icon');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  int id = 0;

  Future<void> requestPermission(BuildContext context) async {
    this.context = context;

    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    print("permission = ${result}");
  }

  Future<void> displayNotification(MatchModel match,
      NotificationType type) async {
    NotificationManager.instance.requestPermission(context);

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('1', 'Notifications',
        channelDescription: 'Eşleşme bildirimleri',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(presentAlert: true,
            presentBadge: true,
            presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
            categoryIdentifier: 'Notifications');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails,
        iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(id++,
        type == NotificationType.forSource
            ? 'Yakınlarınızda konaklama ihtiyacı doğdu.'
            : 'Konaklama aradığınız bölgede yeni bir ilan var.',
        'Detaylar için tıklayın.', notificationDetails,
        payload: match.id);
  }

  void onDidReceiveLocalNotification(int id, String? title,
      String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title!),
            content: Text(body!),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  // await Navigator.push(
                  //   context,
                  // MaterialPageRoute(
                  // builder: (context) => SecondScreen(payload),
                  // ),
                  // );
                },
              )
            ],
          ),
    );
  }
}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sos/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
part 'messages_controller.g.dart';

class MessageController {
  final Ref ref;
  MessageController({required this.ref}) {
    // init();
  }
  void init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    // await FlutterLocalNotificationsPlugin().show(
    //     0, 'plain title', 'Initialized', notificationDetails,
    //     payload: 'item x');

    final goRouter = ref.read(goRouterProvider);

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      debugPrint('statement');
      await FlutterLocalNotificationsPlugin().show(
          0, 'Need help', 'onMessageOpenedApp', notificationDetails,
          payload: 'item x');
      Map data = event.data;
      goRouter.push(
          '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
    });

    FirebaseMessaging.onMessage.listen((event) async {
      debugPrint(event.toString());
      Map data = event.data;
      goRouter.push(
          '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
      await FlutterLocalNotificationsPlugin().show(
          0, 'Need help', 'onMessage', notificationDetails,
          payload: 'item x');
    });
  }
}

@riverpod
MessageController messageController(MessageControllerRef ref) {
  return MessageController(ref: ref);
}

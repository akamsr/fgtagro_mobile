import 'dart:convert';
import 'dart:io';
import 'package:fgtagro_mobile/utils/log/log.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future<void> requestPermission() async {
    //Instantiate FCM
    final settings = await getrequest();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      DevLog.show(
        "The user has accepted push notification",
        name: "PUSH_NOTIFICATION_STATUS",
      );
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      DevLog.show(
        "The user has denied push notification",
        name: "PUSH_NOTIFICATION_STATUS",
      );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      DevLog.show(
        "The user has provisional access to push notification",
        name: "PUSH_NOTIFICATION_STATUS",
      );
    }
  }

  Future<NotificationSettings> getrequest() async {
    final NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
    return settings;
  }

  Future<String> getToken() async {
    final _firebaseMessaging = await FirebaseMessaging.instance;
    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        return await FirebaseMessaging.instance.getToken() ?? '';
      } else {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          return await FirebaseMessaging.instance.getToken() ?? '';
        } else {
          return '';
        }
      }
    } else {
      return await FirebaseMessaging.instance.getToken() ?? '';
    }
  }

  void handleMessage(RemoteMessage message) {
    DevLog.show(message.data.toString(), name: 'NOTIFICATION');
    // NotificationNavigation.mapRoute(jsonDecode(message.data['data']));
  }

  Future<void> setupInteractedMessage() async {
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      await Future.delayed(const Duration(seconds: 5), () {
        handleMessage(initialMessage);
      });
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void initInfo() {
    const androidInitialize = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    const iosInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        DevLog.show(details.payload.toString(), name: 'MESSAGE RECEIVED');
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      DevLog.show(message.data.toString(), name: 'INIT INFO');

      if (notification != null) {
        await flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            iOS: const DarwinNotificationDetails(),
            android: android != null
                ? AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    importance: Importance.max,
                    icon: android.smallIcon,
                    channelDescription: channel.description,
                  )
                : null,
          ),
        );
      }
    });
  }

  //method used in triggerring firebase background messaging
  @pragma('vm:entry-point')
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // await Firebase.initializeApp();

    // debugPrint("${message.messageId}" + " HANDLING A BACKGROUND MESSAGE");
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    DevLog.show(message.data.toString(), name: 'INIT INFO');
    final Map<String, dynamic> data = jsonDecode((message.data['data']));

    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          iOS: const DarwinNotificationDetails(),
          android: android != null
              ? AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  importance: Importance.max,
                  icon: android.smallIcon,
                  channelDescription: channel.description,
                )
              : null,
        ),
      );
    }
  }
}

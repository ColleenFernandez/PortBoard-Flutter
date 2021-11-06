import 'dart:convert';

import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> fcmBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
}

class FCMService {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> init() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Common.fcmToken = (await FirebaseMessaging.instance.getToken())!;

    LogUtils.log(Common.fcmToken);

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    if (!kIsWeb){
      channel = const AndroidNotificationChannel(
        'fcmBackgroundChannel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification!.android;
      if(notification != null && android != null && !kIsWeb) {

        LogUtils.log('foregroundMsg ====> ${message.data}');
        //FBroadcast.instance().broadcast(Constants.JOB_DETAIL, value: message.data);

        AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'noti_icon',
            importance: Importance.high,
            sound: RawResourceAndroidNotificationSound('noti_sound')
        );

        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics
        );

        await flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            platformChannelSpecifics);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LogUtils.log('A new onMessageOpenedApp event was published!');
    });
  }

}
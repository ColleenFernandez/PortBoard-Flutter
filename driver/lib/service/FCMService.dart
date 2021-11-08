import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

Future<void> fcmBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();

  // show local notification
  RemoteNotification? notification = remoteMessage.notification;
  AndroidNotification? android = remoteMessage.notification!.android;
  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id,
      channel.name,
      icon: 'noti_icon',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('noti_sound')
  );

  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics
  );

  await flutterLocalNotificationsPlugin.show(
      0,
      notification!.title,
      notification.body,
      platformChannelSpecifics);

  // play custom sound
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  final filename = 'noti_sound.mp3';
  var bytes = await rootBundle.load("assets/sound/noti_sound.mp3");
  String dir = (await getApplicationDocumentsDirectory()).path;
  final  notiSoundFile = await writeToFile(bytes,'$dir/$filename');
  final notiSoundPath = notiSoundFile.path;

  if (notiSoundPath != null && File(notiSoundPath).existsSync()){
    audioPlayer.play(notiSoundPath, isLocal: true);
    audioPlayer.onPlayerCompletion.listen((event) {
    });
  }
}

Future<File> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

AndroidNotificationChannel channel =  const AndroidNotificationChannel(
  'driver_noti_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();

class FCMService {

  Future<void> init() async{
    await Firebase.initializeApp();
    Common.fcmToken = (await FirebaseMessaging.instance.getToken())!;

    LogUtils.log(Common.fcmToken);

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    if (!kIsWeb){
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

        LogUtils.log('fgNotifiation ===> ${message.notification!.android!.priority.toString()}');
        //FBroadcast.instance().broadcast(Constants.JOB_DETAIL, value: message.data);

        AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'noti_icon',
            importance: Importance.high,
            playSound: true,
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
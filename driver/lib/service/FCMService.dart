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
import 'package:driver/utils/Utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:volume_control/volume_control.dart';

Future<void> fcmBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();

  LogUtils.log('backgroundNotiData ===> ${remoteMessage.data}');

  // show local notification
  RemoteNotification? notification = remoteMessage.notification;

  if (Platform.isAndroid){
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
    if (notification.title == Constants.NOTI_NEW_JOB_REQUEST_TITLE){
      VolumeControl.setVolume(Constants.SOUND_VOL);
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

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized){
      LogUtils.log('User granted permission');
    }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      LogUtils.log('User granted provisional permission');
    }else  {
      LogUtils.log('User declined or has not accepted permission');
    }

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

      if (Platform.isAndroid){
        AndroidNotificationDetails androidNotiDetail = AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'noti_icon',
            importance: Importance.high,
        );

        NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidNotiDetail,
        );

        await flutterLocalNotificationsPlugin.show(
            0,
            notification!.title,
            notification.body,
            platformChannelSpecifics);

        // play custom sound
        if (notification.title ==  Constants.NOTI_NEW_JOB_REQUEST_TITLE){
          VolumeControl.setVolume(Constants.SOUND_VOL);
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
      }

      if (Platform.isIOS){
        /*final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async{}
        );

        IOSNotificationDetails iosNotiDetal = IOSNotificationDetails(
            sound: 'noti_sound.aiff'
        );

        NotificationDetails platformChannelSpecifics = NotificationDetails(
          iOS: iosNotiDetal
        );

        await flutterLocalNotificationsPlugin.show(
            0,
            notification!.title,
            notification.body,
            platformChannelSpecifics);*/
      }

      if (notification!.title == Constants.NOTI_NEW_JOB_REQUEST_TITLE){
        getJobRequest();
      }

      final notiType = message.data as Map<String, dynamic>;
      final notiTag = notiType[APIConst.tag];
      if (notiTag == Constants.NOTI_DOCUMENT_VERIFY_STATUS){
        FBroadcast.instance().broadcast(Constants.NOTI_DOCUMENT_VERIFY_STATUS);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LogUtils.log('A new onMessageOpenedApp event was published!');
    });
  }

  void getJobRequest(){
    Common.api.getJobRequest(Common.userModel.id).then((value) {
      if (value is String){
        showToast(value);
      }else {
        Common.jobRequest = value as JobModel;
        FBroadcast.instance().broadcast(Constants.JOB_REQUEST);
      }
    });
  }
}
import 'dart:convert';

import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/provider/users_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider{

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotifications() async{
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMMessageListener(){
    // Trabajamos con notificaciones en el segundo plano
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('Nueva notificacion : $message');
      }
    });

    // Recibir las notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });


    // Esto es lo que se ejecuta cuando damos clic
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void saveToken(User user, BuildContext context ) async{
    // Con esto obtenemos el token
    String token  =  await FirebaseMessaging.instance.getToken();
    // Lo guardamos en la base de datos
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init( context , sessionUser: user);
    await usersProvider.updateNotificationToken(user.id, token);
  }

  // PPara ennviar mensajes de uno a uno
  void sendMessage(String to , Map<String, dynamic> data , String title, String body) async{
    //Esta es la ruta que nos permitira enviar notificaciones
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(uri, headers: <String,String>{
      'Content-Type' : 'application/json',
      'Authorization' :  'key=AAAAXq5BKHk:APA91bH1Oz8SLR88TPmQTFUabPdV07x6ijMcfmHIlSCUGapX8h8Xn068pnwmOYvHT3l4-r7cotVW7KzT9Zkz15GlJoPE_5iZe-QHqrcOyUkCWXVVfaosrxdks9Nn0kF29MVIOvLtnX64'
    } , body: jsonEncode(<String, dynamic>{
      'notification' : <String, dynamic>{
        'body' :  body,
        'title': title
      },
      'priority' : 'high',
      'ttl' : '4500s',
      'data' : data,
      'to' : to
    })
    );
  }

}
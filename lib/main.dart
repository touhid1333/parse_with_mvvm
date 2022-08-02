import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/common/services/custom_methods.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart' as di;
import 'package:parse_with_mvvm/screens/Filter/filter_view.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard.dart';
import 'package:parse_with_mvvm/screens/login/login_view.dart';
import 'package:parse_with_mvvm/screens/not_found/not_found.dart';
import 'package:parse_with_mvvm/screens/signup/signup_view.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  //ensure widget initializations
  WidgetsFlutterBinding.ensureInitialized();

  //Dot Env extension implement
  await dotenv.load(fileName: ".env");
  di.initDev();

  //parse server initialization
  final keyApplicationId = dotenv.env['PARSE_APPLICATION_ID'] ?? '';
  final keyClientKey = dotenv.env['PARSE_CLIENT_KEY'] ?? '';
  final keyParseServerUrl = dotenv.env['PARSE_SERVER_URL'] ?? '';
  final liveQueryUrl = dotenv.env['PARSE_LIVE_QUERY_URL'] ?? '';

  if (keyApplicationId.isNotEmpty &&
      keyClientKey.isNotEmpty &&
      keyParseServerUrl.isNotEmpty) {
    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true,
      autoSendSessionId: true,
      liveQueryUrl: liveQueryUrl.isNotEmpty ? liveQueryUrl : keyParseServerUrl,
    );
  }

  //awesome notification initialization
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'default_notifications',
        channelName: 'Default Notifications',
        channelDescription: 'Default channel is for normal notifications.',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        defaultColor: Colors.red,
        ledColor: Colors.yellow,
      ),
    ],
    debug: true,
  );

  //firebase
  // Create the initialization for your desired push service here
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  //check fcm token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("____$fcmToken------");

  //background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //notification firebase permissions
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /*NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );*/

  //foreground notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    //AwesomeNotifications().createNotificationFromJsonData(message.data);

    /*String? imageUrl;
      imageUrl ??= message.notification!.android?.imageUrl;
      imageUrl ??= message.notification!.apple?.imageUrl;*/

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUID(),
          channelKey: 'default_notifications',
          title: message.notification!.title,
          body: message.notification!.body,
          notificationLayout: message.notification!.android!.imageUrl != null ? NotificationLayout.BigPicture : NotificationLayout.Default,
          bigPicture: message.notification!.android!.imageUrl
        ),
      );


      /*notificationLayout: AwesomeStringUtils.isNullOrEmpty(imageUrl)
          ? NotificationLayout.Default
          : NotificationLayout.BigPicture,
    bigPicture: imageUrl,*/
  });

  runApp(const MyApp());
}

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Graphik',
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          onPrimary: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            // Home route
            if (routeSettings.name == LoginView.routeName) {
              return const LoginView();
            } else if (routeSettings.name == SignUpView.routeName) {
              return const SignUpView();
            } else if (routeSettings.name == Dashboard.routeName) {
              return const Dashboard();
            } else if (routeSettings.name == FilterView.routeName) {
              return const FilterView();
            } else {
              return const NotFound();
            }
          },
        );
      },
    );
  }
}

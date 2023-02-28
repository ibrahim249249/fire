// ignore_for_file: depend_on_referenced_packages, duplicate_import
// ignore: unused_import
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fire_app/login.dart';
//import 'package:fire_app/login.dart';
// ignore: unused_import
import 'package:fire_app/main_menu.dart';
import 'package:fire_app/main_minu.dart';
// ignore: unused_import
import 'package:fire_app/pierodec.dart';
import 'package:fire_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

void main() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notification',
          channelDescription: 'Notification channel for basic tests')
    ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sharedPref.getString("id") == null ? LoginPage() : const MainMenu(),
    );
  }
}

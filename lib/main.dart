// ignore_for_file: depend_on_referenced_packages, duplicate_import
// ignore: unused_import
import 'package:fire_app/dashboard.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

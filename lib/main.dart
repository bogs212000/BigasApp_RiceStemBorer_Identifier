import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:change_app_package_name/change_app_package_name.dart';
import 'TfliteModel.dart';
import 'onbording.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Bigas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: showHome ? const TfliteModel() : Onbording(),
    );
  }
}

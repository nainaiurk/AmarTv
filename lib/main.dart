// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, unused_catch_clause, sized_box_for_whitespace
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:live_tv/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:live_tv/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  RequestConfiguration configuration =
  RequestConfiguration();
  MobileAds.instance.updateRequestConfiguration(configuration);
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amr TV',
      theme: themeNotifier.getTheme(),
      home: const MyHomePage(
        title: 'Amr TV',
    ));
  }
}

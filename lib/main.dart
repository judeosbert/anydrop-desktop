import 'dart:io';

import 'package:AnyDrop/helpers/SharedPrefManager.dart';
import 'package:AnyDrop/pages/UpdatePage.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'pages/HomePage.dart';

void main() {
  _setTargetPlatformForDesktop();
  initComponents();
  runApp(MyApp());
}

void initComponents() async {
  SharedPrefManager();
}

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'AnyDrop - Desktop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        UpdatePage.routeName: (context) => UpdatePage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}

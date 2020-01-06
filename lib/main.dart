import 'package:AnyDrop/pages/UpdatePage.dart';
import 'package:flutter/material.dart';

import 'pages/HomePage.dart';

void main() => runApp(MyApp());

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
        HomePage.routeName:(context) => HomePage(),
        UpdatePage.routeName:(context) => UpdatePage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}

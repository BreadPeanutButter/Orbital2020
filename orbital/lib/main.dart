import 'package:flutter/material.dart';
import 'package:orbital/screens/wrapper.dart';

import 'screens/activity_feed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCA App',
      initialRoute: '/',
      routes: {
        '/': (BuildContext ctx) => Wrapper(),
        '/activity': (BuildContext ctx) => ActivityFeed(),
      },
      
    );
  }
}

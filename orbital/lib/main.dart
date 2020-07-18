import 'package:flutter/material.dart';
import 'package:orbital/anonymous/explore_anonymous.dart';
import 'screens/event_feed/event_feed.dart';
import 'screens/explore/explore.dart';
import 'package:orbital/screens/authetication/sign_in.dart';

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
        '/': (BuildContext ctx) => SignIn(),
        '/explore': (BuildContext ctx) => Explore(),
        '/eventfeed': (BuildContext ctx) => EventFeed(),
        '/exploreanonymous' : (BuildContext ctx) => ExploreAnonymous()
      },
    );
  }
}

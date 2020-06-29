import 'package:flutter/material.dart';
import 'package:orbital/my_events/my_events.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'profile.dart';

enum Drawers { eventfeed, explore, event, profile }

class AppDrawer extends StatelessWidget {
  Drawers drawer;
  Auth auth;

  AppDrawer({@required this.drawer}) {
    auth = new Auth();
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Column(children: <Widget>[
      DrawerHeader(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset("images/logo.png", fit: BoxFit.fill)),
      ),
      Ink(
          color: drawer == Drawers.explore ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_one),
            title: Text('Explore CCAs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.pushNamed(context, '/explore'),
          )),
      Ink(
          color: drawer == Drawers.eventfeed ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_two),
            title: Text('Event Feed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.pushNamed(context, '/eventfeed'),
          )),
      Ink(
          color: drawer == Drawers.event ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_3),
            title: Text('My Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => MyEvents(
                          auth: auth,
                        ))),
          )),
      Ink(
          color: drawer == Drawers.profile ? Colors.blue : Colors.transparent,
          child: ListTile(
            leading: Icon(Icons.looks_4),
            title: Text('My Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Profile(
                          auth: auth,
                        ))),
          )),
    ]));
  }
}

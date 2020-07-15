import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/my_ccas/my_ccas.dart';
import 'package:orbital/my_events/my_events.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'profile.dart';

enum Drawers { eventfeed, explore, bookmark, profile, myCCAs }

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
          decoration: BoxDecoration(
            color: drawer == Drawers.explore
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.explore
                ? Border.all(width: 2, color: Colors.grey[600])
                : null,
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.globeAmericas,
              size: 35,
              color: drawer == Drawers.explore
                  ? Colors.blue[900]
                  : Colors.blue[600],
            ),
            title: Text('Explore CCAs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => Navigator.pushNamed(context, '/explore'),
          )),
      Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.myCCAs
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.myCCAs
                ? Border.all(width: 2, color: Colors.grey[600])
                : null,
          ),
          child: ListTile(
            leading: Icon(FontAwesomeIcons.crown,
                size: 35, color: Colors.yellow[700]),
            title: Text('My CCAs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => MyCCAs(
                          auth: auth,
                        ))),
          )),
      Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.eventfeed
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.eventfeed
                ? Border.all(width: 2, color: Colors.grey[600])
                : null,
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.newspaper,
              color: drawer == Drawers.eventfeed
                  ? Colors.grey[800]
                  : Colors.grey[700],
              size: 35,
            ),
            title: Text('Event Feed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => Navigator.pushNamed(context, '/eventfeed'),
          )),
      Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.bookmark
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.bookmark
                ? Border.all(width: 2, color: Colors.grey[700])
                : null,
          ),
          child: ListTile(
            leading: Icon(Icons.bookmark, size: 35, color: Colors.orange),
            title: Text('Bookmarked Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => MyEvents(
                          auth: auth,
                        ))),
          )),
      Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.profile
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.profile
                ? Border.all(width: 2, color: Colors.grey[600])
                : null,
          ),
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 35,
              color:
                  drawer == Drawers.profile ? Colors.green[800] : Colors.green,
            ),
            title: Text('Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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

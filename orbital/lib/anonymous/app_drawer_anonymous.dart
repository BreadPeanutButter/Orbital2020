import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/favourites/favourites.dart';
import 'package:orbital/my_ccas/my_ccas.dart';
import 'package:orbital/my_events/my_events.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';


enum Drawers {explore , logout}

class AppDrawerAnonymous extends StatelessWidget {
  Drawers drawer;

  AppDrawerAnonymous({@required this.drawer}) {
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
            onTap: () => Navigator.pushNamed(context, '/explore_anonymous'),
          )),
          SizedBox(height: 480,),
          Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.logout
                ? Colors.blue[400]
                : Colors.transparent,
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.powerOff,
              size: 35,
              color: drawer == Drawers.logout
                  ? Colors.blue[900]
                  : Colors.blue[600],
            ),
            title: Text('Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          })
          ))
    ]));
  }
}

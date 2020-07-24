import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orbital/favourites/favourites.dart';
import 'package:orbital/my_ccas/my_ccas.dart';
import 'package:orbital/my_events/my_events.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'profile.dart';

enum Drawers {
  eventfeed,
  explore,
  bookmark,
  profile,
  myCCAs,
  favourites,
  logout
}

class AppDrawer extends StatelessWidget {
  Drawers drawer;
  Auth auth;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  AppDrawer({@required this.drawer}) {
    auth = new Auth();
  }

  Future<Null> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  signOut(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  void _successDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("You have logout from your account"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            OutlineButton(
                highlightedBorderColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue),
                child: new Text("Ok"),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  });
                }),

            SizedBox(width: 110),
          ],
        );
      },
    );
  }

  Drawer drawerWidget(BuildContext context) {
    bool googleSignedIn = auth.googleSignedIn;
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
            color: drawer == Drawers.favourites
                ? Colors.blue[400]
                : Colors.transparent,
            border: drawer == Drawers.favourites
                ? Border.all(width: 2, color: Colors.grey[600])
                : null,
          ),
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.solidStar,
              size: 35,
              color: Colors.orange,
            ),
            title: Text('Favourite CCAs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Favourites(
                          auth: auth,
                        ))),
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
            leading: Icon(Icons.bookmark, size: 35, color: Colors.deepOrange),
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
      SizedBox(
        height: 160,
      ),
      Ink(
          decoration: BoxDecoration(
            color: drawer == Drawers.logout
                ? Colors.blue[400]
                : Colors.transparent,
          ),
          child: ListTile(
              leading:
                  Icon(FontAwesomeIcons.powerOff, size: 35, color: Colors.red),
              title: Text('Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
              onTap: () => !googleSignedIn
                  ? signOut(context)
                  : {signOutGoogle(), _successDialog(context)}))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    if (auth.name.isEmpty || auth.email.isEmpty) {
      return FutureBuilder(
          future: auth.getCurrentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return drawerWidget(context);
            }
          });
    } else {
      return drawerWidget(context);
    }
  }
}

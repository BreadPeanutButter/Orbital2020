import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital/cca/create_cca.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

import '../app_drawer.dart';
import 'explore_all.dart';
import 'explore_category.dart';

class Explore extends StatelessWidget {
  Auth auth = new Auth();
  int index;

  Explore() {
    this.index = 0;
  }
  Explore.tab({@required this.index});

  static const categories = <Text>[
    Text('All'),
    Text('Academic'),
    Text('Adventure'),
    Text('Arts'),
    Text('Cultural'),
    Text('Health'),
    Text('Social Cause'),
    Text('Specialist'),
    Text('Sports'),
    Text('Technology')
  ];

  @override
  Widget build(BuildContext context) {
    void maxCCAsDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Opps! Prohibited action"),
            content: new Text(
                "You are already the Admin of 10 CCAs which is the maximum. You cannot create anymore CCAs."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        },
      );
    }

    return DefaultTabController(
        initialIndex: index,
        length: 10,
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Explore CCAs', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
              Ink(
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: CircleBorder(
                          side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ))),
                  child: IconButton(
                    highlightColor: Colors.blue[700],
                    icon: Icon(Icons.add),
                    iconSize: 35,
                    onPressed: () async {
                      List ccaList = (await auth.getAdminCCAs()).toList();
                      if (ccaList.length < 10) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateCCA()));
                      } else {
                        maxCCAsDialog();
                      }
                    },
                    color: Colors.white,
                  ))
            ],
            bottom: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 22.0),
              indicatorColor: Colors.amber[700],
              indicatorWeight: 4.0,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[50],
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.whatshot),
                  child: categories[0],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.book),
                  child: categories[1],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.campground),
                  child: categories[2],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.penSquare),
                  child: categories[3],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.peopleCarry),
                  child: categories[4],
                ),
                Tab(
                  icon: Icon(Icons.fitness_center),
                  child: categories[5],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.handsHelping),
                  child: categories[6],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.atom),
                  child: categories[7],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.footballBall),
                  child: categories[8],
                ),
                Tab(
                  icon: Icon(Icons.laptop_chromebook),
                  child: categories[9],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ExploreAll(auth: auth),
              ExploreCategory(category: "Academic"),
              ExploreCategory(category: "Adventure"),
              ExploreCategory(category: "Arts"),
              ExploreCategory(category: "Cultural"),
              ExploreCategory(category: "Health"),
              ExploreCategory(category: "Social Cause"),
              ExploreCategory(category: "Specialist"),
              ExploreCategory(category: "Sports"),
              ExploreCategory(category: "Technology"),
            ],
          ),
          drawer: AppDrawer(drawer: Drawers.explore),
        ));
  }
}

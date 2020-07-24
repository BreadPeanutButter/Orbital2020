import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:orbital/anonymous/app_drawer_anonymous.dart';
import 'explore_all_anonymous.dart';
import 'explore_category_anonymous.dart';

class ExploreAnonymous extends StatelessWidget {
  int index;

  ExploreAnonymous() {
    this.index = 0;
  }
  ExploreAnonymous.tab({@required this.index});

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
    return DefaultTabController(
        initialIndex: index,
        length: 10,
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Explore CCAs', style: TextStyle(color: Colors.black)),
            centerTitle: true,
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
              ExploreAllAnonymous(),
              ExploreCategoryAnonymous(category: "Academic"),
              ExploreCategoryAnonymous(category: "Adventure"),
              ExploreCategoryAnonymous(category: "Arts"),
              ExploreCategoryAnonymous(category: "Cultural"),
              ExploreCategoryAnonymous(category: "Health"),
              ExploreCategoryAnonymous(category: "Social Cause"),
              ExploreCategoryAnonymous(category: "Specialist"),
              ExploreCategoryAnonymous(category: "Sports"),
              ExploreCategoryAnonymous(category: "Technology"),
            ],
          ),
          drawer: AppDrawerAnonymous(drawer: Drawers.explore),
        ));
  }
}

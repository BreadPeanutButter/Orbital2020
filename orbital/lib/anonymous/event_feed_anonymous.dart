import 'package:flutter/material.dart';
import 'package:orbital/anonymous/app_drawer_anonymous.dart';
import 'package:orbital/anonymous/event_feed_all_anonymous.dart';
import 'package:orbital/anonymous/event_feed_category_anonymous.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventFeedAnonymous extends StatelessWidget {
  final database = Firestore.instance;
  int index;

  EventFeedAnonymous() {
    index = 0;
  }
  EventFeedAnonymous.tab({this.index});

  static const categories = <Text>[
    Text('Favourites'),
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
            title: Text('Event Feed', style: TextStyle(color: Colors.black)),
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
                  child: categories[1],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.book),
                  child: categories[2],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.campground),
                  child: categories[3],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.penSquare),
                  child: categories[4],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.peopleCarry),
                  child: categories[5],
                ),
                Tab(
                  icon: Icon(Icons.fitness_center),
                  child: categories[6],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.handsHelping),
                  child: categories[7],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.atom),
                  child: categories[8],
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.footballBall),
                  child: categories[9],
                ),
                Tab(
                  icon: Icon(Icons.laptop_chromebook),
                  child: categories[10],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              EventFeedAllAnonymous(),
              EventFeedCategoryAnonymous(category: "Academic"),
              EventFeedCategoryAnonymous(category: "Adventure"),
              EventFeedCategoryAnonymous(category: "Arts"),
              EventFeedCategoryAnonymous(category: "Cultural"),
              EventFeedCategoryAnonymous(category: "Health"),
              EventFeedCategoryAnonymous(category: "Social Cause"),
              EventFeedCategoryAnonymous(category: "Specialist"),
              EventFeedCategoryAnonymous(category: "Sports"),
              EventFeedCategoryAnonymous(category: "Technology"),
            ],
          ),
          drawer: AppDrawerAnonymous(drawer: Drawers.eventfeed),
        ));
  }
}

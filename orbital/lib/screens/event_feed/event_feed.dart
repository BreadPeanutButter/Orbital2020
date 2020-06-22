import 'package:flutter/material.dart';
import 'event_feed_all.dart';
import 'event_feed_category.dart';
import 'package:orbital/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app_drawer.dart';

class EventFeed extends StatelessWidget {
  final database = Firestore.instance;
  Auth auth = new Auth();

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
                  icon: Icon(Icons.star),
                  child: categories[8],
                ),
                Tab(
                  icon: Icon(Icons.directions_bike),
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
              EventFeedAll(auth: auth),
              EventFeedCategory(auth: auth, category: "Academic"),
              EventFeedCategory(auth: auth, category: "Adventure"),
              EventFeedCategory(auth: auth, category: "Arts"),
              EventFeedCategory(auth: auth, category: "Cultural"),
              EventFeedCategory(auth: auth, category: "Health"),
              EventFeedCategory(auth: auth, category: "Social Cause"),
              EventFeedCategory(auth: auth, category: "Specialist"),
              EventFeedCategory(auth: auth, category: "Sports"),
              EventFeedCategory(auth: auth, category: "Technology"),
            ],
          ),
          drawer: AppDrawer(drawer: Drawers.eventfeed),
        ));
  }

}

import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

import '../app_drawer.dart';
import 'explore_all.dart';

class Explore extends StatelessWidget {
  static const categories = <Text>[
    Text('Favourites'),
    Text('All'),
    Text('Academic'),
    Text('Adventure'),
    Text('Arts'),
    Text('Social Cause'),
    Text('Cultural'),
    Text('Health'),
    Text('Sports'),
    Text('Technology')
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                    highlightColor: Colors.blue[900],
                    icon: Icon(Icons.add),
                    iconSize: 35,
                    onPressed: () {Navigator.pushNamed(context, '/createcca');},
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
                  icon: Icon(Icons.star),
                  child: categories[0],
                ),
                Tab(
                  icon: Icon(Icons.whatshot),
                  child: categories[1],
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: categories[2],
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: categories[3],
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: categories[4],
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: categories[5],
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: categories[6],
                ),
                Tab(
                  icon: Icon(Icons.fitness_center),
                  child: categories[7],
                ),
                Tab(
                  icon: Icon(Icons.directions_bike),
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
              categories[0],
              ExploreAll(),
              categories[2],
              categories[3],
              categories[4],
              categories[5],
              categories[6],
              categories[7],
              categories[8],
              categories[9]
            ],
          ),
          drawer: AppDrawer(drawer: Drawers.explore),
        ));
  }
}

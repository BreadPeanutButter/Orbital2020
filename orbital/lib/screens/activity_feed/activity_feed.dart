import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

import '../app_drawer.dart';

class ActivityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Activity Feed'),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 22.0),
              indicatorColor: Colors.amber[700] ,
              indicatorWeight: 4.0,
              labelColor: Colors.amber[800],
              unselectedLabelColor: Colors.grey[50],
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.whatshot),
                  child: Text('All'),
                ),
                Tab(
                  icon: Icon(Icons.star),
                  child: Text('My Favourites'),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Text('All: Display List of all CCAs queried from Cloud Firebase'),
              Text('Favourite: Display List of favourite CCAs queried from Cloud Firebase')
            ],),
          drawer: AppDrawer(),
        ));
  }
}

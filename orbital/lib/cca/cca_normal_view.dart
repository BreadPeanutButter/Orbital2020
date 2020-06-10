import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';


class CCANormalView extends StatelessWidget {

  final name;

  CCANormalView({this.name});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(name, style: TextStyle(color: Colors.black)),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 22.0),
              indicatorColor: Colors.amber[700],
              indicatorWeight: 4.0,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[50],
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.star),
                  child: Text("About"),
                ),
                Tab(
                  icon: Icon(Icons.whatshot),
                  child: Text("Events"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [Text("About"), Text("Events")],
          ),
        ));
  }
}
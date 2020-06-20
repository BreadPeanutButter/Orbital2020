import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

import '../app_drawer.dart';

class EventFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text('Activity Feed', style: TextStyle(color: Colors.black)),
          centerTitle: true),
      drawer: AppDrawer(drawer: Drawers.eventfeed),
    );
  }
}

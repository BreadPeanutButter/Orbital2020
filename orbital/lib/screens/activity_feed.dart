import 'package:flutter/material.dart';
import 'package:orbital/services/auth.dart';
import 'package:flutter/cupertino.dart';

import 'app_drawer.dart';

class ActivityFeed extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: Text('Activity Feed'), centerTitle: true),
      body: new Text('Display List of CCAs queried from Cloud Firebase'),
      drawer: AppDrawer(),
    );
  }

}
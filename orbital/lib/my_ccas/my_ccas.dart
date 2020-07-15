import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orbital/services/auth.dart';
import 'package:orbital/cca/cca_admin_view.dart';
import 'package:orbital/screens/app_drawer.dart';

class MyCCAs extends StatelessWidget {
  Auth auth;
  final collectionRef = Firestore.instance.collection('CCA');
  Future<List> adminOf;
  List adminOfList;
  MyCCAs({@required this.auth}) {
    adminOf = auth.getAdminCCAs();
  }

  Widget buildBody(int index) {
    return FutureBuilder(
        future: collectionRef.document(adminOfList[index]).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return new SizedBox(
                height: 100,
                child: Card(
                    shape: RoundedRectangleBorder(
                        side:
                            new BorderSide(color: Colors.grey[600], width: 1.0),
                        borderRadius: BorderRadius.circular(4.0)),
                    margin: EdgeInsets.all(3),
                    elevation: 1.0,
                    shadowColor: Colors.blue,
                    child: InkWell(
                        highlightColor: Colors.blueAccent,
                        onTap: () => {},
                        child: ListTile(
                          title: new Text(snapshot.data['Name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 22)),
                          subtitle: new Text(snapshot.data['Category'],
                              style: TextStyle(fontSize: 20)),
                        ))));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('My CCAs', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      drawer: AppDrawer(drawer: Drawers.myCCAs),
      body: FutureBuilder(
          future: adminOf,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              adminOfList = snapshot.data.reversed.toList();
              if (adminOfList.isEmpty) {
                return Center(
                    child: Text(
                  'You are not the Admin of any CCAs',
                  style: TextStyle(fontSize: 30),
                ));
              } else {
                return ListView.builder(
                    itemCount: adminOfList.length,
                    itemBuilder: (BuildContext ctx, int index) =>
                        buildBody(index));
              }
            }
          }),
    );
  }
}

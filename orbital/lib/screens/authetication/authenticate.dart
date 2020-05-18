import 'package:flutter/material.dart';
import 'package:orbital/screens/authetication/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AutheticateState createState() => _AutheticateState();
}

class _AutheticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn()
    );
  }
}

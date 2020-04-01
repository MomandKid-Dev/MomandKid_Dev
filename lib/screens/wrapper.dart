// import libraries
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import files
import 'package:momandkid/models/user.dart';
import 'package:momandkid/screens/authenticate/authenticate.dart';
import 'package:momandkid/screens/home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return MyHomePage();
    }
  }
}

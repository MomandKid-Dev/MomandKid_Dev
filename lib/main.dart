// import libraries
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import file
import 'package:momandkid/models/user.dart';
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          fontFamily: 'Prompt',
        ),
      ),
    );
  }
}

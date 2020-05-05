import 'package:flutter/material.dart';
import 'package:momandkid/root_page.dart';
import 'package:momandkid/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(auth: Auth()),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Prompt',
      ),
    );
  }
}

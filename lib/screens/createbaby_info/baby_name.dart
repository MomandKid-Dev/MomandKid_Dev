import 'package:flutter/material.dart';

class BabyName extends StatefulWidget {
  @override
  _BabyNameState createState() => _BabyNameState();
}

class _BabyNameState extends State<BabyName> {
  @override
  Widget build(BuildContext context) {
    print('in baby');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New baby'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){},
            icon: Icon(Icons.arrow_back_ios),
            label: Text('back'),
          ),
        ],
      ),
      body: Container(
        child: Text('Baby'),
      ),
    );
  }
}

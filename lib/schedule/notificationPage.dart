import 'package:flutter/material.dart';

class MyNotificationPage extends StatefulWidget {
  MyNotificationPage({Key key}) : super(key: key);

  @override
  _MyNotificationPageState createState() => _MyNotificationPageState();
}

class MyTabs {
  final String title;
  final Color color;
  MyTabs({this.title,this.color});
}

class _MyNotificationPageState extends State<MyNotificationPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      backgroundColor: Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Notification',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.6,
                fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xFFFF7572),
              iconSize: 30.0,
              alignment: Alignment(0.0, 0.5),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 10.0,
            expandedHeight: 62.0,
            floating: true,
          ),

          SliverList(
            delegate: SliverChildListDelegate([ //Add list in notification
              
            ]),
          )
        ],
      ),
    );
  }
}
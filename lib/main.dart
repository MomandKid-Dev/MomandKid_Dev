

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  // static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
  theme: new ThemeData(
    fontFamily: 'Montserrat',
  ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E8E9),
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'MomAndKids.',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 24
        ),
        
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none),
          alignment: Alignment(2.0,0.0),
          color: Colors.pink, 
          iconSize: 25.0,
          onPressed: () {
            print('Notification');
          }
          ),
        
        IconButton(
          icon: Icon(LineAwesomeIcons.cog),
          alignment: Alignment(0.0,-0.2),
          color: Colors.pink, 
          iconSize: 25.0,
          onPressed: () {
            print('Setting');
          }
          ),
      ],
      leading: IconButton(
        icon: Icon(
          LineAwesomeIcons.user,
          color: Colors.pink,
          size: 35.0,
          ),
        alignment: Alignment(0.0,-1.0),
        onPressed: (){
          print('Account');
        },
      ),
    ),
    bottomNavigationBar: BottomNavyBar(
      selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0 : print('home');
              break;
            case 1 : print('Article');
              Navigator.push(
                context, 
                PageTransition(type: PageTransitionType.rightToLeft, child: MyArticlePage()),
                // MaterialPageRoute(builder: (context) => MyArticlePage()),
                
                );
              break;
            default:
          }
          print(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon : Icon(LineAwesomeIcons.home),
            activeColor: Colors.red,
            inactiveColor: Colors.black,

          ),
          BottomNavyBarItem(
            title: Text('Article'),
            icon: Icon(Icons.apps),
            activeColor: Colors.pink,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Kids'),
            icon: Icon(Icons.chat_bubble),
            activeColor: Colors.purple,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Health'),
            icon: Icon(Icons.settings),
            activeColor: Colors.blue,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Schedule'),
            icon: Icon(Icons.settings),
            activeColor: Colors.green,
            inactiveColor: Colors.black
          ),
        ],
      ),
    );
  }
}

class MyArticlePage extends StatefulWidget {
  MyArticlePage({Key key}) : super(key: key);

  @override
  _MyArticlePageState createState() => _MyArticlePageState();
}

class _MyArticlePageState extends State<MyArticlePage> {

  int _currentIndex = 1;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2E8E9),
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Article.',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 24
        ),
        
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none),
          alignment: Alignment(2.0,0.0),
          color: Colors.pink, 
          iconSize: 25.0,
          onPressed: () {
            print('Notification');
          }
          ),
        
        IconButton(
          icon: Icon(LineAwesomeIcons.cog),
          alignment: Alignment(0.0,-0.2),
          color: Colors.pink, 
          iconSize: 25.0,
          onPressed: () {
            print('Setting');
          }
          ),
      ],
      leading: IconButton(
        icon: Icon(
          LineAwesomeIcons.user,
          color: Colors.pink,
          size: 35.0,
          ),
        alignment: Alignment(0.0,-1.0),
        onPressed: (){
          print('Account');
          
        },
      ),
    ),
    bottomNavigationBar: BottomNavyBar(
      selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0 : print('home');
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              break;
            case 1 : print('Article');
              break;
            default:
          }
          print(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon : Icon(LineAwesomeIcons.home),
            activeColor: Colors.red,
            inactiveColor: Colors.black,

          ),
          BottomNavyBarItem(
            title: Text('Article'),
            icon: Icon(Icons.apps),
            activeColor: Colors.pink,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Kids'),
            icon: Icon(Icons.chat_bubble),
            activeColor: Colors.purple,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Health'),
            icon: Icon(Icons.settings),
            activeColor: Colors.blue,
            inactiveColor: Colors.black
          ),
          BottomNavyBarItem(
            title: Text('Schedule'),
            icon: Icon(Icons.settings),
            activeColor: Colors.green,
            inactiveColor: Colors.black
          ),
        ],
      ),
    );
  }
}
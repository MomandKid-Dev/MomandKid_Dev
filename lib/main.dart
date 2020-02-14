import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

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
        fontFamily: 'Dosis',
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
  int currentIndex;
  PageController _pageController;
  var selectedCard = 'WEIGHT';

  String _title;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    currentIndex = 0;
    _title = 'Home';
  }
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      switch (index) {
        case 0:
          _title = 'Home' ;
          break;
        case 1:
          _title = 'Article' ;
          break;
        case 2:
          _title = 'Page 3' ;
          break;
        case 3:
          _title = 'Page 4' ;
          break;
        case 4:
          _title = ' ' ;
          break;
        default:
      }
      _pageController.jumpToPage(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFB),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
            fontSize: 30.0,
            ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.user), 
          color: Color(0xFF9FA2A7),
          iconSize: 30.0,
          onPressed: (){
            
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineAwesomeIcons.bell), 
            onPressed: (){
              Navigator.push(
              context,
              PageRouteTransition(
                animationType: AnimationType.slide_right,
                builder: (context) => MyNotificationPage())
              );
            }
            )
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
              switch (index) {
                case 0:
                  _title = 'Home' ;
                  break;
                case 1:
                  _title = 'Article' ;
                  break;
                case 2:
                  _title = 'Page 3' ;
                  break;
                case 3:
                  _title = 'Page 4' ;
                  break;
                case 4:
                  _title = ' ' ;
                  break;
                default:
              }
            } );
          },
          children: <Widget>[
            Container(color: Colors.white,),
            Container(color: Colors.blue,),
            Container(color: Colors.blue,),
            Container(color: Colors.green,),
            Container(color: Colors.blue,),
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        elevation: 20,
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Colors.red, 
              icon: Icon(Icons.dashboard, color: Color(0xFF9FA2A7),), 
              activeIcon: Icon(Icons.dashboard, color: Colors.red,), 
              title: Text("Home")
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple, 
              icon: Icon(Icons.access_time, color: Color(0xFF9FA2A7),), 
              activeIcon: Icon(Icons.access_time, color: Colors.deepPurple,), 
              title: Text("Logs")
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.indigo, 
              icon: Icon(Icons.folder_open, color: Color(0xFF9FA2A7),), 
              activeIcon: Icon(Icons.folder_open, color: Colors.indigo,), 
              title: Text("Folders")
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green, 
              icon: Icon(Icons.menu, color: Color(0xFF9FA2A7),), 
              activeIcon: Icon(Icons.menu, color: Colors.green,), 
              title: Text("Menu")
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.green, 
              icon: Icon(Icons.menu, color: Color(0xFF9FA2A7),), 
              activeIcon: Icon(Icons.menu, color: Colors.green,), 
              title: Text("Menu")
            )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
      onTap: () {
        selectCard(cardTitle);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cardTitle == selectedCard ? Color(0xFF7A9BEE) : Colors.white,
          border: Border.all(
            color: cardTitle == selectedCard ? 
            Colors.transparent :
            Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
          width: 0.75
          ),
          
        ),
        height: 100.0,
        width: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15.0),
              child: Text(cardTitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0,
                    color:
                        cardTitle == selectedCard ? Colors.white : Colors.grey.withOpacity(0.7),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(info,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                  Text(unit,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        color: cardTitle == selectedCard
                            ? Colors.white
                            : Colors.black,
                      ))
                ],
              ),
            )
          ]
        )
      )
    );
  }
  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}

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
              _buildFoodItem('assets/plate1.png', 'Salmon bowl', '\$24.00'),
              _buildFoodItem('assets/plate2.png', 'Spring bowl', '\$22.00'),
              _buildFoodItem('assets/plate3.png', 'Avocado bowl', '\$26.00'),
              _buildFoodItem('assets/plate5.png', 'Berry bowl', '\$24.00'),
              _buildFoodItem('assets/plate4.png', 'Avocado bowl', '\$26.00'),
            ]),
          )
        ],
      ),
          
    );
  }



  Widget _buildFoodItem(String imgPath, String foodName, String price){
    return Padding(
      padding: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Hero(
                    tag: imgPath,
                    child: Image(
                      image: AssetImage(imgPath),
                      fit: BoxFit.cover,
                      height: 75.0,
                      width: 75.0,
                      )
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15.0,
                          color: Colors.grey
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.add), onPressed: () {},color: Colors.black
            )
          ],
        ),
      ),
    );
  }
}

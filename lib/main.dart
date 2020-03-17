import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:momandkid/schedulePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Prompt',
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
  var selectedCard = '0';
  bool _visible = true;
  bool _showappbar = true;
  bool _showsche = false;
  String _title, _titleScheItem = '';
  List dataTitleSche = [], colorSche = [], dataDesSche = [];

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
          _visible = true;
          _showappbar = true;
          break;
        case 1:
          _title = 'Article' ;
          _visible = false;
          _showappbar = true;
          break;
        case 2:
          _title = ' ' ;
          _visible = false;
          _showappbar = false;
          break;
        case 3:
          _title = ' ' ;
          _visible = false;
          _showappbar = false;
          break;
        case 4:
          _title = ' ' ;
          _visible = false;
          _showappbar = false;
          break;
        default:
      }
      _pageController.jumpToPage(currentIndex);
    });
  }

  void moveToAddPage() async {
    final information = await Navigator.push(
                                context,
                                PageRouteTransition(
                                  fullscreenDialog: true,
                                  animationType: AnimationType.slide_up,
                                  builder: (context) => addSchedule())
                              );
    
    if(information[0].length > 0)
    {
      setState(() {
        _titleScheItem = information[0];
        dataTitleSche.add(information[0]);
        colorSche.add(information[2]);
        dataDesSche.add(information[3]);
        });
    }
    if(dataTitleSche.length > 0){
      setState(() {
        _showsche = true;
      });
    }
    print(colorSche);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFB),
      key: _scaffoldKey,
      appBar: _showappbar ? AppBar(
        title: Text(_title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
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
            color: Color(0xFF9FA2A7),
            iconSize: 30.0,
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
      )
        : PreferredSize(
        child: Container(),
        preferredSize: Size(0.0, 0.0),
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
                  _visible = true;
                  _showappbar = true;
                  break;
                case 1:
                  _title = 'Article' ;
                  _visible = false;
                  _showappbar = true;
                  break;
                case 2:
                  _title = 'Page 3' ;
                  _visible = false;
                  _showappbar = false;
                  break;
                case 3:
                  _title = 'Page 4' ;
                  _visible = false;
                  _showappbar = false;
                  break;
                case 4:
                  _title = ' ' ;
                  _visible = false;
                  _showappbar = false;

                  break;
                default:
              }
            } );
          },
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.only(left: 10.0, right: 10.0), 
                children: <Widget>[
                  SizedBox(height: 30,),
                  Container(
                    height: 330.0,
                    width: 370.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 5.0)
                      )
                      ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 330.0,
                    width: 370.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 5.0)
                      )
                      ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 330.0,
                    width: 370.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 5.0)
                      )
                      ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 330.0,
                    width: 370.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[100],
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 5.0)
                      )
                      ]
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                children: <Widget>[
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF8FAFB)
                    ),
                    
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        filled: false,
                        contentPadding: EdgeInsets.only(top: 15.0),
                        fillColor: Color(0xFFF8FAFB),
                        prefixIcon: Icon(Icons.search,size: 35.0,),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFF131048)
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Catagories",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.6,
                            color: Color(0xFF131048)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 120.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              _buildInfoCard('3', 'NO', 'All')
                            ],
                          )
                        ),
                        SizedBox(width: 20.0,),
                        Container(
                          child: Row(
                            children: <Widget>[
                              
                              _buildInfoCard('0', 'assets/Pictures/grai.png', 'GRAINS'),
                            ],
                          )
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          child: Row(
                            children: <Widget>[
                              _buildInfoCard('1', 'assets/Pictures/veg.png', 'VEGGIES'),
                            ],
                          )
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          child: Row(
                            children: <Widget>[
                              _buildInfoCard('2', 'assets/Pictures/fru.png', 'FRUITS'),
                            ],
                          )
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFF131048)
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.6,
                            color: Color(0xFF131048)
                          ),
                        ),
                        SizedBox(width: 182,),
                        FlatButton(
                          onPressed: (){
                            
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                "view all",
                                style: TextStyle(
                                  color: Color(0xFFACB2B9),
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Color(0xFFACB2B9),
                                )
                            ],
                          ),
                        )
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(color: Colors.blue,),
            Container(color: Colors.green,),
            Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Pictures/pinkBG.jpg'),
                        fit: BoxFit.cover
                        ), 
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0))
                    ),
                    child: Container(
                      alignment: Alignment(1, 1.2),
                      child: Container(
                        height: 85,
                        width: 85,
                        child: new RawMaterialButton(
                          onPressed: () {},
                          child: new Icon(
                            Icons.today,
                            color: Color(0xFF141148),
                            size: 40,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    )
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      Spacer(flex: 2,),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF141048)
                        ),
                        ),
                      Spacer(flex:12),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 30,),
                        onPressed: (){
                          moveToAddPage();
                        },
                      ),
                      Spacer(flex: 1)
                    ],
                  ),
                  _showsche ? SizedBox(
                    height: 300,
                    
                    child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: dataTitleSche.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                            height: 100,
                            child: Card(
                              color: Color(0xFFEFEFEF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.only(top: 10, left: 20),
                                onTap: (){},
                                title: Row(
                                  children: <Widget>[
                                    Container(width: 5, height: 40,color: colorSche[index]),
                                    SizedBox(width: 5),
                                    Text(
                                      dataTitleSche[index],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(dataDesSche[index]),
                              ),
                            )
                          );
                        },
                      ),
                    )
                    : PreferredSize(
                      child: Container(),
                      preferredSize: Size(0.0, 0.0),)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: _visible ? 1:0,
        child: FloatingActionButton(
        backgroundColor: Color(0xFF76C5BA),
        child: Icon(Icons.edit,size: 30.0,),
        onPressed: (){
          
        }
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
          borderRadius: BorderRadius.circular(18.0)
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                gap: 5,
                activeColor: Color(0xFFFF7571),
                iconSize: 22,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Color(0xFFFFD5D4),
                tabs: [
                  GButton(
                    icon: LineAwesomeIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineAwesomeIcons.heart_o,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: LineAwesomeIcons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: LineAwesomeIcons.user,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: LineAwesomeIcons.user,
                    text: 'Schedule',
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  setState(() {
                    currentIndex = index;
                    changePage(currentIndex);
                  });
                }),
          ),
        ),
      ),
    );
  }



  Widget _buildInfoCard(String cardTitle, String imgPath, String unit) {
    return InkWell(

      onTap: () {
        selectCard(cardTitle);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cardTitle == selectedCard ? Color(0xFFA2D0D2) : Colors.white,
          border: Border.all(
            color: cardTitle == selectedCard ? 
            Colors.transparent :
            Colors.grey.withOpacity(0.3),
            style: BorderStyle.none,
          width: 0.75,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              spreadRadius: 3.0,
              offset: Offset(5.0, 5.0),
              color: Color(0xFFF8FAFF)
            )
          ]
        ),
        height: 95.0,
        width: 95.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 12,),
                  Image(
                    image: AssetImage(imgPath),
                    fit: BoxFit.fitHeight,
                    height: 50,
                    ),
                  SizedBox(height: 5,),
                  Text(unit,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: cardTitle == selectedCard
                            ? Colors.white
                            : Color(0xFFACB2B9),
                      ),
                      )
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

  Widget _buildPostCard(String imgPath, String info)
  {
    return InkWell(
      onTap: (){},
      child: ListView(

      ),
    );
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

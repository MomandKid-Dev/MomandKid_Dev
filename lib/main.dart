// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/detailsPage.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  // static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      appBar: AppBar(
        backgroundColor: Color(0xFF21BFBD),
        elevation: 0.0,
        actions: <Widget>[
                IconButton(
                  alignment: Alignment(-40.0,0.0),
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 22.0,
                  color: Colors.white, 
                  onPressed: () {},
                  ),
                Container(
                  width: 125.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 50.0,
                        color: Colors.white,
                        onPressed: () {},
                        ),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        iconSize: 30.0,
                        color: Colors.white,
                        onPressed: () {},
                        ),
                    ],
                  ),
                ),   
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10.0,left:20.0) ,
            child: Row(
              
            ),
          ),
          SizedBox(height: 25.0,),
          Padding(
            padding: EdgeInsets.only(left:40.0),
            child: Row(
              children: <Widget>[
                Text('Healthy',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(width: 10.0),
                Text('Food',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 25.0,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 100.0,),
        Container(
          height: MediaQuery.of(context).size.height - 185.0,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0))),
          child: ListView(
            primary: false,
            padding: EdgeInsets.only(left: 25.0, right: 20.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:45.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 300.0,
                  child: ListView(children:[
                    _buildFoodItem('assets/plate1.png', 'Salmon bowl', '\$24.00'),
                    _buildFoodItem('assets/plate2.png', 'Spring bowl', '\$22.00'),
                    _buildFoodItem('assets/plate3.png', 'Avocado bowl', '\$26.00'),
                    _buildFoodItem('assets/plate5.png', 'Berry bowl', '\$24.00'),
                    _buildFoodItem('assets/plate4.png', 'Avocado bowl', '\$26.00'),
                    _buildFoodItem('assets/plate6.png', 'Avocado bowl', '\$26.00'),
                    ],
                  ),
                ),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 65.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                ),
                Container(
                  height: 65.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Icon(Icons.shopping_basket, color: Colors.black),
                  ),
                ),
                Container(
                  height: 65.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF1C1428)),
                  child: Center(
                      child: Text('Checkout',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 15.0))),
                  )
                ],
              )
            ],
          ),
        )
        ],
      ),
    );
  }
  Widget _buildFoodItem(String imgPath, String foodName, String price){
    return Padding(
      padding: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsPage(heroTag : imgPath, foodName : foodName, foodPrice : price)
          ));
        },
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
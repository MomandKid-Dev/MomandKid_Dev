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
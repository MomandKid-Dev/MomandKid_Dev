import 'package:flutter/material.dart';

class mainArticle extends StatefulWidget {
  @override
  _mainArticleState createState() => _mainArticleState();
}

class _mainArticleState extends State<mainArticle> {

  var selectedCard = '0';

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Row(
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
                Spacer(flex: 1),
                FlatButton(
                  padding: EdgeInsets.only(left:20),
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
}
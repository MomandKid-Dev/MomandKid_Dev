import 'package:flutter/material.dart';
import 'dart:async';
class mainArticle extends StatefulWidget {
  @override
  _mainArticleState createState() => _mainArticleState();
}

class _mainArticleState extends State<mainArticle> {

  static List listDrink = ['assets/article/drink/01.png', 'assets/article/drink/02.png', 'assets/article/drink/03.png', 'assets/article/drink/04.png', 'assets/article/drink/05.png', 'assets/article/drink/06.png', 'assets/article/drink/07.png'];
  static List listMeat = ['assets/article/meat/01.png', 'assets/article/meat/02.png', 'assets/article/meat/03.png', 'assets/article/meat/04.png', 'assets/article/meat/05.png', 'assets/article/meat/06.png', 'assets/article/meat/07.png', 'assets/article/meat/08.png', 'assets/article/meat/09.png'];
  static List listMilk = ['assets/article/milk/01.png', 'assets/article/milk/02.png', 'assets/article/milk/03.png', 'assets/article/milk/04.png', 'assets/article/milk/05.png', 'assets/article/milk/06.png'];
  List all = listDrink + listMeat + listMilk;
  var selectedCard = '0';

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                height: 30,
                color: Colors.red,
              )
            ],
          ),
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
            children: <Widget>[
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
                          _buildInfoCard('3', 'assets/Pictures/grai.png', 'All')
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
                  ],
                ),
              ),
              SizedBox(height: 10,),
              if(selectedCard == '0')
                for (var i = 0; i < listDrink.length; i++) 
                  Image.asset(listDrink[i])
              else if(selectedCard == '1')
                for (var i = 0; i < listMeat.length; i++) 
                  Image.asset(listMeat[i])
              else if(selectedCard == '2')
                for (var i = 0; i < listMilk.length; i++) 
                  Image.asset(listMilk[i])
              else
                for (var i = 0; i < all.length; i++) 
                  Image.asset(all[i])
            ],
          ),
        ],
      )
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
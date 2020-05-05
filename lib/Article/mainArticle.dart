import 'package:flutter/material.dart';
import 'dart:async';
class mainArticle extends StatefulWidget {
  @override
  _mainArticleState createState() => _mainArticleState();
}

class _mainArticleState extends State<mainArticle> {

  static List listDrink = ['assets/article/drink/01d.png', 'assets/article/drink/02d.png', 'assets/article/drink/03d.png', 'assets/article/drink/04d.png', 'assets/article/drink/05d.png', 
                          'assets/article/drink/06d.png', 'assets/article/drink/07d.png', 'assets/article/drink/08d.png', 'assets/article/drink/09d.png', 'assets/article/drink/10d.png',
                          'assets/article/drink/11d.png', 'assets/article/drink/12d.png', 'assets/article/drink/13d.png', 'assets/article/drink/14d.png', 'assets/article/drink/15d.png',
                          'assets/article/drink/16d.png', 'assets/article/drink/17d.png', 'assets/article/drink/18d.png', 'assets/article/drink/19d.png', 'assets/article/drink/20d.png'];
  static List listMeat = ['assets/article/meat/01m.png', 'assets/article/meat/02m.png', 'assets/article/meat/03m.png', 'assets/article/meat/04m.png', 'assets/article/meat/05m.png', 
                          'assets/article/meat/06m.png', 'assets/article/meat/07m.png', 'assets/article/meat/08m.png', 'assets/article/meat/09m.png', 'assets/article/meat/10m.png',
                          'assets/article/meat/11m.png', 'assets/article/meat/12m.png', 'assets/article/meat/13m.png', 'assets/article/meat/14m.png', 'assets/article/meat/15m.png',
                          'assets/article/meat/16m.png', 'assets/article/meat/17m.png', 'assets/article/meat/18m.png', 'assets/article/meat/19m.png', 'assets/article/meat/20m.png'];
  static List listVeg = ['assets/article/veggies/01v.png', 'assets/article/veggies/02v.png', 'assets/article/veggies/03v.png', 'assets/article/veggies/04v.png', 'assets/article/veggies/05v.png', 
                          'assets/article/veggies/06v.png', 'assets/article/veggies/07v.png', 'assets/article/veggies/08v.png', 'assets/article/veggies/09v.png', 'assets/article/veggies/10v.png',
                          'assets/article/veggies/11v.png', 'assets/article/veggies/12v.png', 'assets/article/veggies/13v.png', 'assets/article/veggies/14v.png', 'assets/article/veggies/15v.png',
                          'assets/article/veggies/16v.png', 'assets/article/veggies/17v.png', 'assets/article/veggies/18v.png', 'assets/article/veggies/19v.png', 'assets/article/veggies/20v.png'];
  static List listFruit = ['assets/article/fruit/01f.png', 'assets/article/fruit/02f.png', 'assets/article/fruit/03f.png', 'assets/article/fruit/04f.png', 'assets/article/fruit/05f.png', 
                          'assets/article/fruit/06f.png', 'assets/article/fruit/07f.png', 'assets/article/fruit/08f.png', 'assets/article/fruit/09f.png', 'assets/article/fruit/10f.png',
                          'assets/article/fruit/11f.png', 'assets/article/fruit/12f.png', 'assets/article/fruit/13f.png', 'assets/article/fruit/14f.png', 'assets/article/fruit/15f.png',
                          'assets/article/fruit/16f.png', 'assets/article/fruit/17f.png', 'assets/article/fruit/18f.png', 'assets/article/fruit/19f.png', 'assets/article/fruit/20f.png'];
  static List listMilk = ['assets/article/milk/01b.png', 'assets/article/milk/02b.png', 'assets/article/milk/03b.png', 'assets/article/milk/04b.png', 'assets/article/milk/05b.png', 'assets/article/milk/06b.png'];
  List all = listVeg + listFruit + listDrink + listMeat + listMilk;
  var selectedCard = '0';

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    color: Color(0xFFEFF5F8)
                  ),
                ),
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
                  padding: EdgeInsets.only(left: 10, right:10),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('5', 'assets/Pictures/stores.png', 'All')
                        ],
                      )
                    ),
                    SizedBox(width: 20.0,),
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('0', 'assets/Pictures/veg.png', 'VEGGIES'),
                        ],
                      )
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('1', 'assets/Pictures/fru.png', 'FRUITS'),
                        ],
                      )
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('2', 'assets/Pictures/drink.png', 'DRINKS'),
                        ],
                      )
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('3', 'assets/Pictures/meat.png', 'MEATS'),
                        ],
                      )
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      child: Row(
                        children: <Widget>[
                          _buildInfoCard('4', 'assets/Pictures/cheese.png', 'Dairy'),
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
              if(selectedCard == '0') //VEG
                for (var i = 0; i < listVeg.length; i++) 
                  Image.asset(listVeg[i])
              else if(selectedCard == '1') //FRUIT
                for (var i = 0; i < listFruit.length; i++) 
                  Image.asset(listFruit[i])
              else if(selectedCard == '2')//DRINK
                for (var i = 0; i < listDrink.length; i++) 
                  Image.asset(listDrink[i])
              else if(selectedCard == '3')//MEAT
                for (var i = 0; i < listMeat.length; i++) 
                  Image.asset(listMeat[i])
              else if(selectedCard == '4')//BEAN
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
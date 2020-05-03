import 'package:flutter/material.dart';
import 'dart:async';
class mainArticle extends StatefulWidget {
  @override
  _mainArticleState createState() => _mainArticleState();
}

class _mainArticleState extends State<mainArticle> {

  static List listDrink = ['assets/article/drink/เครื่องดื่มชูกำลัง.png', 'assets/article/drink/โคล่า.png', 'assets/article/drink/ชาดำ.png', 'assets/article/drink/นมถั่วเหลือง.png', 'assets/article/drink/น้ำผึ้ง.png', 'assets/article/drink/น้ำส้ม.png', 'assets/article/drink/เบียร์.png'];
  static List listMeat = ['assets/article/meat/กระดูกหมู.png', 'assets/article/meat/ไข่ไก่.png', 'assets/article/meat/เคบับแกะ.png', 'assets/article/meat/เครื่องในไก่.png', 'assets/article/meat/ตีนไก่.png', 'assets/article/meat/เนื้อวัว.png', 'assets/article/meat/เนื้อหมู.png', 'assets/article/meat/ปีกไก่.png', 'assets/article/meat/ไส้กรอกหมู.png'];
  static List listMilk = ['assets/article/milk/เต้าหู้ขาวอ่อน.png', 'assets/article/milk/เต้าหู้ทอด.png', 'assets/article/milk/ถั่วพุ่ม.png', 'assets/article/milk/นมผง.png', 'assets/article/milk/โยเกิร์ต.png', 'assets/article/milk/ไอศกรีม.png'];
  List all = listDrink + listMeat + listMilk;
  var selectedCard = '0';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
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
            // Image.asset('assets/article/drink/เครื่องดื่มชูกำลัง.png')
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
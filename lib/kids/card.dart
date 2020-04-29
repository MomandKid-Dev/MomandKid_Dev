import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/healthCard.dart';
import 'DataTest.dart';

class card extends StatefulWidget{
  card({this.data,this.type, this.list});
  dataTest data;
  List<Map<dynamic,dynamic>> list;
  String type;
  @override 
  _cardState createState() => _cardState();
}

class _cardState extends State<card>{
  @override 
  Widget build(BuildContext context){
    // print(widget.list.runtimeType);
    return Container(
      margin: EdgeInsets.only(top:30),
      padding: EdgeInsets.only(bottom: 20),
      // width: MediaQuery.of(context).size.width / 1.13,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: getAllCard(context, widget.data, widget.list,widget.type)
    );
  }
}

getAllCard(BuildContext context, dataTest data, List<Map<dynamic,dynamic>> list,String type){
  return Column(
    children: <Widget>[
      allcard(context, data, list,type)
    ],
  );
}

Widget allcard(BuildContext context,dataTest data,List<Map<dynamic,dynamic>> list,String type)=> new Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[

    Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text('Today,'),
          Text('${toDate(list[0]['Date'])}')
        ],
      )
    ),

    Container(
      // color: Colors.red,
      padding: EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('จำนวน${data.getTitle(type)}',style: TextStyle(fontSize: 17),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('${list.length} ',style: TextStyle(fontSize: 20)), 
              Text('${data.getTitle(type)}',style: TextStyle(fontSize: 17)),
              // Text(data.getTitle(type))
            ],
          )
        ],
      ),
    ),
    
    getCard(context,data,list,type)

  ],
);

getCard(BuildContext context,dataTest data,List<Map<dynamic,dynamic>> list, String type){
  return Column(
    // children: ,
    children: list.map((e)=>cards(context,data, type, list , e)).toList()
    // children: <Widget>[
    //   cards(context,data, type)
    // ],
  );
}

Widget cards(BuildContext context,dataTest data, String type,List<Map<dynamic,dynamic>> real ,Map<dynamic,dynamic> list) => new GestureDetector(
  onTap: (){
    data.setRecent(list['id']);
    // print('This is recent ${data.getRecent()}');
    Route route = MaterialPageRoute(builder: (context) => healthCard(data: data,type: type,list: list,));
    Navigator.push(context, route);
  },
  child:Container(
    color: Colors.white,
    padding: EdgeInsets.only(left: 20,right: 20, bottom: 10,top: 10),

    // color: Colors.red,
    // height: ,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right:10),
              
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.red,
                border: Border.all(width: 0.3),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('${data.getImg(type)}'),
                )
              ),
              
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.getSubval(type) == '' ? 
              <Widget>[
                Text('${data.getVal(type)}'),
              ]:
              <Widget>[
                Text('${data.getVal(type)}'),
                Text('${data.getSubval(type)}')
              ] 
              ,
            )
            
          ],
        ),
        Text('อายุ ${data.getAge()} เดือน')

      ],
    ),
  )
);


toDate(String date){
  String newDate = '';
  List month = ['January','February','March','May','June','July','August','September','October','November','December'];
  newDate += date.substring(0,2);
  newDate += ' ';
  newDate += month[int.parse(date.substring(2,3))];
  newDate += ' ';
  newDate += date.substring(4,8);
  return newDate;
}
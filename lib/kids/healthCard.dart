import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/shared/style.dart';
import 'DataTest.dart';

class healthCard extends StatefulWidget{
  healthCard({this.data,this.type, this.list});
  dataTest data;
  String type;
  Map<dynamic,dynamic> list;
  @override
  _healthCardState createState() => _healthCardState();
}

class _healthCardState extends State<healthCard>{
  @override
  Widget build(BuildContext context){

    var cardHeight = 0;
    if(widget.type == 'evo'){
      cardHeight = 1;
    }
    else if(widget.type == 'vac'){
      cardHeight = 1;
    }
    
    // dataTest card = new dataTest(widget.type);
    dataTest card = widget.data;
    // print('This is ${card.getData(widget.type)[0][0]['a'].length}');
    bool exit = false;
    // test card = new test(widget.type);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(255, 226, 241, 1),Color.fromRGBO(233, 242, 255, 1)]
          )
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTapDown: (TapDownDetails details){
                    exit = true;
                  },
                  onTapCancel: (){
                    if(exit){
                      Navigator.pop(context);
                    }
                  },
                child:Container(
                  // height: (120*test().getKeys().length).toDouble(),
                  height:(220 + 56 * (2 + cardHeight)).toDouble(),
                  padding: EdgeInsets.only(top:20,left: 20, right: 20),
                  width: MediaQuery.of(context).size.width/1.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset(card.getImg(widget.type),height: 56,width: 56,),
                          Container(
                            child:Text(card.getTitle(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 20,color: Color(0xff131048),fontWeight: FontWeight.normal),),
                            padding: EdgeInsets.only(bottom: 30), 
                          ),
                          
                          Text(card.getVal(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 30,color: Color(0xff131048),fontWeight: FontWeight.w700),),
                          Container(
                            child:Text(card.getSubval(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 14,color: Color(0xff131048),fontWeight: FontWeight.normal),),
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          table(context,widget.type,card, widget.list)
                        ],
                      )
                    ],
                  ),
                ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: RawMaterialButton(
                          
                          child: Container(
                            child: Image.asset('assets/icons/check-circle.png'),
                          ),
                          onPressed: (){
                            widget.data.setDatasStat(widget.list['id'], widget.list['type']);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left:50,right:20),
                          child:RawMaterialButton(
                            child: Container(
                              child: Image.asset('assets/icons/trash-alt.png'),
                            ),
                            onPressed: (){
                              widget.data.setDatas(widget.list['id'], widget.list['type']);
                              Navigator.pop(context);
                            },
                          ),
                        )
                      )
                    ],
                  ),
                )
                
              ],
            )
          ]
        ),
      )
    );
  }
}

table(BuildContext context,String type, dataTest card, Map<dynamic,dynamic> list){
  // print(list);
  List temp = new List();
  var tableList;
  if(list != null){
    
    if( (type == 'evo'.toString()) | (type == 'vac'.toString())){
    tableList = [
      tab('ช่วงอายุ',list['range'],),
      Divider(height: 30,),
      tab(card.getTitle(type),list['val']),
      Divider(height: 30,),
      tab('Date',toDate(list['Date']))
    ];
    }
    else{
      tableList =[
        tab(card.getTitle(type),list['val']),
        Divider(height: 30,),
        tab('Date',toDate(list['Date']))
      ];
    }
  }
  else{
    tableList =[
      tab(card.getTitle(type),null),
      Divider(height: 30,),
      tab('Date',null)
    ];
  }
  
  
  
  // print(card.getData()[0]['a'].map((e)=>print(e.keys)));
  // print(card.getData()[0]['a'].forEach((a,b)=>print(a,b)));
  // print(card.getData()[0]['a'].forEach((k,v)=>print(k)));
  // print(list['val']);
  // print(list['title']);
  Widget tables() => Column(
    // children: list.map((e)=> tab())
    
    //children:<Widget>[((e)=> tab(e,list['a'][e],temp.length,temp.indexOf(e))).toList()],
    children: tableList
    // children: card.getData()[0]['a'].forEach((k)=>tab('a','a',0,0)).toList(),
    // children: ((card.getData()[0])['a']).map<Widget>((e)=>tab(e,'a',0,0)).toList(),
    // children: (card.getData()[0])['a'].map((e)=>tab(e['title'],e['val'],e.length,i)).toList(),
  );
  return tables();
}

Widget tab(String key, String value) => new Container(
  // padding: EdgeInsets.only(top:16,bottom: 16),
  decoration: BoxDecoration(
    // border: size == index + 1 ? Border() : Border(bottom: BorderSide(
    //   color: Color(0xff8988A2),
    //   width: 0.5
    // )) ,
  ),
  child:Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(key,style:TextStyle(fontSize: 20,color: Color(0xff131048))),
      value == null ? 
      Container(
        width: 100,
        child:TextField(
          
        )
      ):
      Text(value,textAlign: TextAlign.right,style: TextStyle(fontSize: 20,color: Color(0xff625BD4))),

      // Expanded(
      //   flex: 4,
      //   child: Container(
          
      //     child:Text(key,style: TextStyle(fontSize: 20,color: Color(0xff131048)),
      //     ),
      //   ),
      // ),
      // Expanded(
      //   flex: 6,
      //   child: Container(
      //     child:Text(value,textAlign: TextAlign.right,style: TextStyle(fontSize: 20,color: Color(0xff625BD4))),
      //   )
      // )
    ],
  )
);
// Row(
//         children: <Widget>[
//           Expanded(
//             flex: 4,
//             child: Text('ช่วงอายุ',style: TextStyle(fontSize: 20,color: Color(0xff131048)),),
//           ),
//           Expanded(
//             flex: 6,
//             child: Text('แรกเกิด',textAlign: TextAlign.right,style: TextStyle(fontSize: 20,color: Color(0xff625BD4))),
//           )
//         ],
//       ),

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

class editCard extends StatefulWidget{
  editCard({this.data,this.type});
  dataTest data;
  String type;
  @override 
  _editCardState createState() => _editCardState();
}

class _editCardState extends State<editCard>{
  
  @override 
  Widget build(BuildContext context){
    var cardHeight = 0;
    if(widget.type == 'evo'){
      cardHeight = 1;
    }
    else if(widget.type == 'vac'){
      cardHeight = 1;
    }
    
    // dataTest card = new dataTest(widget.type);
    dataTest card = widget.data;
    // print('This is ${card.getData(widget.type)[0][0]['a'].length}');
    bool exit = false;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body:ListView(
        physics: BouncingScrollPhysics(),
        padding: edgeAll(0),
        children:<Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(255, 226, 241, 1),Color.fromRGBO(233, 242, 255, 1)]
              )
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      // onTapDown: (TapDownDetails details){
                      //   exit = true;
                      // },
                      // onTapCancel: (){
                      //   if(exit){
                      //     Navigator.pop(context);
                      //   }
                      // },
                    child:Container(
                      // height: (120*test().getKeys().length).toDouble(),
                      height:(220 + 56 * (2 + cardHeight)).toDouble(),
                      padding: EdgeInsets.only(top:20,left: 20, right: 20),
                      width: MediaQuery.of(context).size.width/1.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.asset(card.getImg(widget.type),height: 56,width: 56,),
                              Container(
                                child:Text(card.getTitle(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 20,color: Color(0xff131048),fontWeight: FontWeight.normal),),
                                padding: EdgeInsets.only(bottom: 30), 
                              ),
                              
                              Text(card.getVal(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 30,color: Color(0xff131048),fontWeight: FontWeight.w700),),
                              Container(
                                child:Text(card.getSubval(widget.type),style: TextStyle(fontFamily: 'Segoe UI',fontSize: 14,color: Color(0xff131048),fontWeight: FontWeight.normal),),
                                padding: EdgeInsets.only(bottom: 20),
                              ),
                              table(context,widget.type,card, null)
                            ],
                          )
                        ],
                      ),
                    ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: 2,
                            child: RawMaterialButton(
                              
                              child: Container(
                                child: Image.asset('assets/icons/check-circle.png'),
                              ),
                              onPressed: (){
                                // widget.data.setDatasStat(widget.list['id'], widget.list['type']);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(left:50,right:20),
                              child:RawMaterialButton(
                                child: Container(
                                  child: Image.asset('assets/icons/trash-alt.png'),
                                ),
                                onPressed: (){
                                  // widget.data.setDatas(widget.list['id'], widget.list['type']);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          )
                        ],
                      ),
                    )
                    
                  ],
                )
              ]
            ),
          )
        ]
      )
    );
  }
}
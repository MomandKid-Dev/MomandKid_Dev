import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';

class editKidData extends StatefulWidget{
  editKidData({this.index, this.data});
  // String img,name;
  Map data;
  int index;
  @override 
  _editState createState() => _editState();
}

class _editState extends State<editKidData>{
  TextEditingController nameController;
  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
      text: widget.data['name']
    );
  }
  @override 
  Widget build(BuildContext context){
    boldtext()=>TextStyle(color: Color(0xff131048),fontWeight: FontWeight.bold,fontSize: 20);

    dialogBox(BuildContext context,String gender){
      return showDialog(context: context,builder: (context)=>
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            padding: edgeAll(20),
            height: 120,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              
                GestureDetector(
                onTap: (){
                  setState(() {
                    widget.data['gender'] = 'm';
                  });
                  
                  Navigator.of(context).pop();
                },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: allRoundedCorner(30),
                      border: Border.all(color:gender == 'm' ? Colors.pink : Colors.grey),
                    ),
                    child:Text('Boy',style: TextStyle(fontSize: 30),),
                  )
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.data['gender'] = 'f';
                    });
                    
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: allRoundedCorner(30),
                      border: Border.all(color:gender == 'f' ? Colors.pink : Colors.grey),
                      
                    ),
                    child: Text('Girl',style: TextStyle(fontSize: 30),),
                  )
                  
                )
              ],
            ),
          )
        )
      );
    }

    calendarBox(BuildContext context){
      return showDatePicker(context: context, initialDate:toDateTime(widget.data['birth']) , firstDate: DateTime(1980), lastDate: DateTime(2222)).then((date){setState(() {
        String newDate = '';
        if(date.day < 10){
          newDate += '0${date.day.toString()}';
        }
        else{
          newDate += date.day.toString();
        }
        if(date.month < 10){
          print(date.month);
          newDate += '0${date.month.toString()}';
        }
        else{
          newDate += date.month.toString();
        }
        newDate += date.year.toString();

        widget.data['birth'] = newDate;
      });});
    }

    return Container(
      decoration: BoxDecoration(
        gradient: gradientBackground()
      ),
      child:Scaffold(
          backgroundColor: Colors.transparent,
          body:Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height - 450,
                child:Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width-40,
                  padding: edgeLR(20),
                  decoration: BoxDecoration(
                    borderRadius: allRoundedCorner(20),
                    color: Colors.white
                  ),
                  margin: edgeAll(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text("Name"),
                            ),

                            Container(
                              // margin: edgeTB(10),
                              child: TextField(
                                controller: nameController,
                                style: boldtext(),
                                decoration: InputDecoration(
                                  border: InputBorder.none
                                )
                              )
                            ),
                            Divider(
                              thickness: 1,
                              
                            )

                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: edgeTB(5),
                              child: Text('Gender')
                            ),
                            GestureDetector(
                              onTap: (){
                                dialogBox(context,widget.data['gender']);
                              },
                              child:Container(
                                width: double.infinity,
                                margin: edgeTB(5),
                                child: widget.data['gender'] == 'm' ? Text('Boy',style: boldtext(),) : Text('Girl',style: boldtext(),)
                              )
                            ),
                            Divider(
                              height: 5,
                              thickness: 1,
                              
                            )
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: edgeTB(5),
                              child: Text('BirthDay'),
                            ),

                            GestureDetector(
                              onTap: (){
                                calendarBox(context);
                              },
                              child:Container(
                                margin: edgeTB(5),
                                child:Text(toDate(widget.data['birth']),style: boldtext(),)
                              )
                            ),
                            Divider(
                              height: 5,
                              thickness: 1,
                            )
                          ],
                        ),
                        
                      ),

                      GestureDetector(
                        onTap: (){
                          widget.data['name'] = nameController.text;
                        },
                        child:SizedBox(
                          width: double.infinity,
                          height:50,
                          child:Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top:10),
                            decoration: BoxDecoration(
                          
                              borderRadius: allRoundedCorner(10),
                              border: Border.all(color:Color(0xffE7E7EC))
                            ),
                            child: Text('Save Change',style: TextStyle(color: Color(0xff625BD4)),),

                          )
                        ),
                        
                      ),
                      GestureDetector(
                        onTap: (){
                          // widget.data['name'] = nameController.text;
                          Navigator.pop(context,true);
                          
                        },
                        child:SizedBox(
                          width: double.infinity,
                          height: 50,
                          child:Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              
                              // borderRadius: allRoundedCorner(20),
                              // border: Border.all(color:Color(0xffE7E7EC))
                            ),
                            child: Text('Delete Profile',style: TextStyle(color: Color(0xff625BD4)),),

                          )
                        ),
                        
                      )

                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height - 500,
                child:Column(
                  children: <Widget>[
                    Hero(
                      tag: 'child${widget.index}',
                      child:circleImg(img:'037-baby.png',height: 150,width: 150,),
                    ),
                    Text('eiei')
                  ],
                ),
              )

            ],
          )
        )
      
    );
  }
}

toDate(String date){
  String newDate = '';
  List month = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  newDate += date.substring(0,2);
  newDate += ' ';
  newDate += month[int.parse(date.substring(2,4))-1];
  newDate += ' ';
  newDate += date.substring(4,8);
  return newDate;
}

toDateTime(String date){
  DateTime newDate = DateTime(int.parse(date.substring(4,8)),int.parse(date.substring(2,4)),int.parse(date.substring(0,2)));
  return newDate;
}
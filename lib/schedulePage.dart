import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class addSchedule extends StatefulWidget {


  @override
  _addScheduleState createState() => _addScheduleState();
}

class _addScheduleState extends State<addSchedule>{

  Color currentColor = Color(0xFFFF4040);
  Color pickerColor = Color(0xFFFF4040);
  List _dataSchedule = [];

  String title,  noti, des; //0 = title, 1 = noti, 2 = des
  
  void changeColor(Color color) => setState(() => pickerColor = color);

  void _addScheItem(String task, int type) { //0 = title, 1 = noti, 2 = des
    // Only add the task if the user actually entered something
    if(task.length > 0) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      if(type == 0)
        setState(() => title = task);
      else if(type == 1)
        setState(() => noti = task);
      else if(type == 2)
        setState(() => des = task);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,//131048
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close), 
          color: Color(0xFF131048),
          iconSize: 40,
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineAwesomeIcons.paper_plane),
            color: Color(0xFF131048),
            iconSize: 40, 
            onPressed: (){
              setState(() {
                _dataSchedule = [title, noti, currentColor, des ];
              });
              Navigator.of(context).pop();
            } 
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:60, right: 40),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add title',
                hintStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt',
                  color: Color(0xFF8A88A4)
                ),
                filled: false,
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                fontFamily: 'Prompt',
                color: Color(0xFF131048)
              ),
              onSubmitted: (val){
                _addScheItem(val, 0);
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left:12, right:40),
            child:TextField(
              decoration: InputDecoration(
                hintText:'Add notification',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt',
                  color: Color(0xFF8A88A4)
                ),
                prefixIcon: Icon(
                  Icons.notifications_none,
                  color: Color(0xFF131048),
                  size: 30,
                  ),
                filled: false,
                border: InputBorder.none
              ),
              style: TextStyle(
                color:Color(0xFF131048)
              ),
              onSubmitted: (val){
                _addScheItem(val, 1);
              },
            )
          ),
          Divider(),
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 13,),
                Container(
                  height: 25,
                  width: 25,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.only(left :2, right:8, top:8, bottom:8),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Select'),
                              onPressed: () {
                                setState(() => currentColor = pickerColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                  }, 
                  child: Text(
                    'Default color',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF131048)
                    ),
                  )
                ), 
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left:12, right:40),
            child:TextField(
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText:'Add description',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt',
                  color: Color(0xFF8A88A4)
                ),
                prefixIcon: Icon(
                  LineAwesomeIcons.comment,
                  color: Color(0xFF131048),
                  size: 30,
                  ),
                filled: false,
                border: InputBorder.none
              ),
              style: TextStyle(
                color:Color(0xFF131048)
              ),
              onSubmitted: (val){
                _addScheItem(val, 2);
              },
            )
          ),
        ],
      ),
    );
  }
}
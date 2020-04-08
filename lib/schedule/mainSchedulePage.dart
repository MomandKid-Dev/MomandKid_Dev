import 'package:flutter/material.dart';
import 'package:momandkid/schedule/calendarTablePage.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:momandkid/schedule/schedulePage.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'calendarTablePage.dart';

class mainSchedule extends StatefulWidget {
  @override
  _mainScheduleState createState() => _mainScheduleState();
}

class _mainScheduleState extends State<mainSchedule> {

  List dataTitleSche = [], colorSche = [], dataDesSche = [], colorBGSche =[], notiSche = [], dateTimeSche = [], _timeSche = [];
  bool _showsche = false;
  DateTime _selectedDate;

  void moveToAddPage() async {
    final information = await Navigator.push(
                                context,
                                PageRouteTransition(
                                  fullscreenDialog: true,
                                  animationType: AnimationType.slide_up,
                                  builder: (context) => addSchedule())
                              );
    
    if(information[0].length > 0)
    {
      setState(() {
        dataTitleSche.add(information[0]);
        notiSche.add(information[1]);
        colorSche.add(information[2]);
        dataDesSche.add(information[3]);
        colorBGSche.add(information[4]);
        dateTimeSche.add(information[5]);
        _timeSche.add(information[6]);
        });
    }
    if(dataTitleSche.length > 0){
      setState(() {
        _showsche = true;
      });
    }
    print(notiSche);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Pictures/pinkBG.jpg'),
                        fit: BoxFit.cover
                        ), 
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0))
                    ),
                    child: Container(
                      alignment: Alignment(1, 1.2),
                      child: Container(
                        height: 85,
                        width: 85,
                        child: new RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteTransition(
                                fullscreenDialog: true,
                                animationType: AnimationType.slide_up,
                                builder: (context) => calendarSchedule())
                            );
                          },
                          child: new Icon(
                            Icons.today,
                            color: Color(0xFF141148),
                            size: 40,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DatePicker(
                          DateTime.now(),
                          height: 80,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Color(0xFFC6E5E6),//c6e5e6
                          selectedTextColor: Color(0xFF141048),
                          unselectionColor: Color(0xFFF8FAFB),
                          dateTextStyle: TextStyle(
                            color: Color(0xFFCACFD3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                          dayTextStyle: TextStyle(
                            color: Color(0xFFCACFD3),
                            fontSize: 10
                          ),
                          monthTextStyle: TextStyle(
                            color: Color(0xFFCACFD3),
                            fontSize: 10
                          ),
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                        ),
                      ],
                  ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      Spacer(flex: 2,),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF141048)
                        ),
                        ),
                      Spacer(flex:12),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 30,),
                        onPressed: (){
                          moveToAddPage();
                        },
                      ),
                      Spacer(flex: 1)
                    ],
                  ),
                  _showsche ? SizedBox(
                    height: 300,
                    child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: dataTitleSche.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                            return _selectedDate.day == dateTimeSche[index].day ? Container(
                              height: 115,
                              child: Card(
                                color: colorBGSche[index],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(top: 10, left: 20),
                                  onTap: (){},
                                  title: Row(
                                    children: <Widget>[
                                      Container(width: 5, height: 40,color: colorSche[index]),
                                      SizedBox(width: 5),
                                      Text(
                                        dataTitleSche[index],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Spacer(flex: 21,),
                                      Text(
                                        _timeSche[index],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Spacer(flex: 3,)
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Text(
                                        dataDesSche[index],
                                        style: TextStyle(
                                          fontSize: 18
                                        ),
                                        ),
                                      Spacer(flex: 18,),
                                      Switch(
                                        value: notiSche[index], 
                                        activeColor: colorSche[index],
                                        onChanged: (value){
                                          notiSche[index] = value;
                                        }
                                      ),
                                      Spacer(flex: 2,)
                                    ],
                                  ),
                                ),
                              )
                            ): PreferredSize(child: Container(), preferredSize: Size(0.0 ,0.0));
                        },
                      ),
                    )
                    : PreferredSize(
                      child: Container(),
                      preferredSize: Size(0.0, 0.0),)
                ],
              ),
    );
  }
}
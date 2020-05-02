import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'dart:async';
import 'package:momandkid/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class calendarSchedule extends StatefulWidget{
  final String userId;
  calendarSchedule({this.userId});
  @override
  _calendarScheduleState createState() => _calendarScheduleState();
}

List scheduleIds = [], dataTitleSche = [], colorSche = [], dataDesSche = [], colorBGSche =[], notiSche = [], dateTimeSche = [], _timeSche = [];
bool _showsche = false, cantScroll = true;
List<Color> listColor = [Color(0xFF99B998),Color(0xFFF7DB4F),Color(0xFFFECEAB),Color(0xFFFF847C),Color(0xFFE84A5F),Color(0xFF6C5B7B),Color(0xFF45ADA8)];
List<Color> listBGColor = [Color(0xFFDBECDB),Color(0xFFFEF0AC),Color(0xFFFFEFE3),Color(0xFFFFD4D1),Color(0xFFF8B3BC),Color(0xFFCCBFD8),Color(0xFFA6CECC)];
List dayOfWeek = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
ScrollController _scrollController = ScrollController();

_scrollToTop(){  _scrollController.jumpTo(_scrollController.position.minScrollExtent);}
class _calendarScheduleState extends State<calendarSchedule>{


  Future loadSchedule() async {
    String _time ='';
    await Database(userId: widget.userId).getScheduleFromUser().then((schedulesId) async {
      if (schedulesId.data == null) return;
      await Database(userId: widget.userId).getSchedulesData(schedulesId.data.keys.toList()).then((schedulesData) async {
        schedulesData.sort((a,b) => a.data['timeset'].compareTo(b.data['timeset']));
        for (DocumentSnapshot schedule in schedulesData){
          if (schedule.data['timeset'].compareTo(Timestamp.now()) < 0) {
            await Database(userId: widget.userId).removeSchedule(schedule.documentID);
            continue;
          }
          DateTime _date = schedule.data['timeset'].toDate();
          if(_date.hour > 9 && _date.minute > 9) _time = '${_date.hour}:${_date.minute}';
          else if(_date.hour > 9 && _date.minute < 10) _time = '${_date.hour}:0${_date.minute}';
          else if(_date.hour < 10 && _date.minute > 9) _time = '0${_date.hour}:${_date.minute}';
          else if(_date.hour < 10 && _date.minute < 10) _time = '0${_date.hour}:0${_date.minute}';
          setState(() {
            scheduleIds.add(schedule.documentID);
            dataTitleSche.add(schedule.data['title']);
            notiSche.add(schedule.data['notification']);
            colorSche.add(listColor[schedule.data['color']]);
            dataDesSche.add(schedule.data['description']);
            colorBGSche.add(listBGColor[schedule.data['color']]);
            dateTimeSche.add(_date);
            _timeSche.add(_time);
          });
        }
        if(dataTitleSche.length > 0){
          setState(() {
            _showsche = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    scheduleIds = []; dataTitleSche = []; colorSche = []; dataDesSche = []; colorBGSche =[]; notiSche = []; dateTimeSche = []; _timeSche = [];
    loadSchedule();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFEFF5F8),
      body: LayoutStarts()
    );
  }
}

class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        calendarSche(),
        CustomBottomSheet(),
      ],
    );
  }
}

class calendarSche extends StatefulWidget{
  
  @override
  _calendarScheState createState() => _calendarScheState();
}

class _calendarScheState extends State<calendarSche>{

  var now = DateTime.now();
  List<String> month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  CalendarCarousel _calendar;

  @override
  Widget build(BuildContext context){

    _calendar = CalendarCarousel(
      showHeader: false,
      weekDayFormat: WeekdayFormat.narrow,
      weekdayTextStyle: TextStyle(
        color: Color(0xFF131048)
      ),
      daysTextStyle: TextStyle(
        color: Color(0xFF131048)
      ),
      weekendTextStyle: TextStyle(
        color: Color(0xFF131048)
      ),
      todayButtonColor: Color(0xFFC6E5E6),
      todayTextStyle: TextStyle(
        color: Color(0xFF131048)
      ),
      
      // onDayPressed: ,
    );

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:25, top: 60),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Color(0xFF131048),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left:40),
            child: Row(
              children: <Widget>[
                Text(
                  month[now.month - 1]+' ${now.day}',
                  style: TextStyle(
                    color: Color(0xFF131048),
                    fontSize: 30,
                    fontWeight: FontWeight.w800
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.only(left:30, right: 30),
            width: 400,
            height: 400,
            child: IgnorePointer(
              ignoring: true,
              child: _calendar,
            )
          )
        ],
      ),
    );
  }
}

class StateBloc {
  StreamController animationController = StreamController();
  final StateProvider provider = StateProvider();

  Stream get animationStatus => animationController.stream;

  void toggleAnimation() {
    provider.toggleAnimationValue();
    animationController.sink.add(provider.isAnimating);
  }

  void dispose() {
    animationController.close();
  }
}

final stateBloc = StateBloc();

class StateProvider {
  bool isAnimating = true;
  void toggleAnimationValue() => isAnimating = !isAnimating;
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 400;
  double minSheetTop = 145;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), 
        vsync: this,
        );
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  forwardAnimation() {
    controller.forward(from: 0);
    print(animation.value);
    stateBloc.toggleAnimation();
    cantScroll = false;
    _scrollToTop();
  }

  reverseAnimation() {
    controller.reverse(from: 1);
    print(animation.value);
    stateBloc.toggleAnimation();
    cantScroll = true;
    _scrollToTop();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          
           controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            //downward drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              // color: Colors.red,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(30), right: Radius.circular(30))
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: MediaQuery.of(context).size.height - 110,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 30),
            child :IgnorePointer(
              ignoring: cantScroll,
              child: _showsche ? ListView.builder(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                itemCount: dataTitleSche.length,
                padding: EdgeInsets.only(bottom: 100),
                itemBuilder: (BuildContext ctxt, int index){
                  return index == 0 || dateTimeSche[index].day > dateTimeSche[index - 1].day || dateTimeSche[index].month > dateTimeSche[index - 1].month || dateTimeSche[index].year > dateTimeSche[index - 1].year ? Container(
                    height: 105,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${dayOfWeek[dateTimeSche[index].weekday - 1]} ${dateTimeSche[index].day}',
                              style: TextStyle(
                                color: Color(0xFF131048),
                                fontSize: 20
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 75,
                          child: ListTile(
                            leading: Text(
                              _timeSche[index],
                              style: TextStyle(
                                color: Color(0xFFCDCED9)
                              ),
                            ),
                            title: Row(
                              children: <Widget>[
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: colorSche[index],
                                    shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  dataTitleSche[index],
                                  style: TextStyle(
                                    color: Color(0xFF131048),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              dataDesSche[index]
                            ),
                          )
                        )
                      ],
                    ),
                  )
                  :Container(
                    height: 75,
                    child: ListTile(
                      leading: Text(
                        _timeSche[index],
                        style: TextStyle(
                          color: Color(0xFFCDCED9)
                        ),
                      ),
                      title: Row(
                        children: <Widget>[
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: colorSche[index],
                              shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            dataTitleSche[index],
                            style: TextStyle(
                              color: Color(0xFF131048),
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        dataDesSche[index]
                      ),
                    )
                  );
                }
              ) : PreferredSize(child: Container(), preferredSize: Size(0.0 ,0.0))
            )
          )
        ],
      ),
    );
  }
}
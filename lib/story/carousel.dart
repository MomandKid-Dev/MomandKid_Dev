import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/shared/style.dart';

class carousel extends StatefulWidget{
  carousel({this.selectedMonth,this.selectedDay});
  int selectedMonth,selectedDay;
  myDate date = new myDate();
  @override 
  _carousel createState() => _carousel();
}

class _carousel extends State<carousel> with TickerProviderStateMixin{
  double distance = 0, position = 0, delta = 0, defaultPos = 0;
  bool dragging = false;
  bool touch = false;
  double opa = 1;
  PageController monthController, dayController;
  AnimationController controller;
  Animation<double> animation;
  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
  
    monthController = PageController(initialPage: widget.selectedMonth-1,viewportFraction: 1/4);
    dayController = PageController(initialPage: widget.selectedDay-1,viewportFraction: 1/4);
  }

  
  @override
  Widget build(BuildContext context){
    List item = ['a','b','c'];
    List indexes = new List();
    item.asMap().forEach((index,val)=>indexes.add(index));
    return Container(
      child:Listener(
        onPointerDown: (PointerDownEvent event){
          setState(() {
            touch = true;
          });
        },
        onPointerUp: (PointerUpEvent event){
          setState(() {
            touch = false;
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: 1,
              child:ClipRect(
                child:BackdropFilter(
                  filter: ImageFilter.blur(sigmaX:10, sigmaY: 10),
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: allRoundedCorner(40),
                      color: Color.fromRGBO(0, 0, 0, 0.1*opa),
                      boxShadow:[BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2*opa) , spreadRadius: 0,blurRadius: 2)]
                    ),
                  ),
                )
              )
            ),
            Wrap(
              direction: Axis.horizontal,
              children:<Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  // color: Colors.red,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                      child:AnimatedOpacity(
                        duration: Duration(milliseconds: 150),
                        opacity: 1,
                        child:Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          child:PageView.builder(
                            itemCount: 12,
                            scrollDirection: Axis.vertical,
                            controller: monthController,
                            physics: BouncingScrollPhysics(),
                            
                            onPageChanged: (int index){
                              setState(() {
                                widget.selectedMonth = index+1;
                              });
                            },
                            itemBuilder: (_,i){
                              if(widget.selectedMonth == null){
                                widget.selectedMonth = 0;
                              }
                              return dateList(i,widget.selectedMonth-1,widget.date.getMonthList(),controller, animation, touch,opa,'month',dayController); 
                            },
                          )
                        )
                      ),
                      ),
                      Container(
                        height: 50,
                        width: 2,
                        color: Colors.white,
                      ),
                      Expanded(
                        flex: 3,
                      child:AnimatedOpacity(
                        duration: Duration(milliseconds: 150),
                        opacity: 1,
                        child:Container(
                          height: 200,
                          
                          width: MediaQuery.of(context).size.width / 6,
                          alignment: Alignment.center,
                          child:PageView.builder(
                            itemCount: widget.date.getDayList(widget.selectedMonth+1).length,
                            scrollDirection: Axis.vertical,
                            controller: dayController,
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (int index){
                              setState(() {
                                widget.selectedDay = index+1;
                              });
                            },
                            itemBuilder: (_,i){
                              if(widget.selectedDay == null){
                                widget.selectedDay = 0;
                              }
                              return dateList(i,widget.selectedDay-1,widget.date.getDayList(3),controller, animation, touch,opa,'day',monthController); 
                            },
                          )
                        )
                      )
                      )
                    ],
                  )
                )
              ]
            )

          ]
        )
      )
    );  
  }
}

dateList(int index,int current,List list,AnimationController controller, Animation<double> animation,bool touch, double opa,String type,PageController pageController){
 
  double alpha = (1 - (((current - index )/10) * 4.3).abs()).toDouble() ;  
  var align;
  if(type == 'day'){
    align = Alignment.center;
  }
  else{
    align = Alignment.center;
  }
  if(touch){
    opa = 1;
  }
  else if(!touch && index != current){
    opa = 0;
  }

  animation = Tween<double>(begin: 1,end: index == current ?  1.5: 1).animate(controller);
  
  return AnimatedOpacity(
  duration: Duration(milliseconds: 200),
  opacity: opa,
  child:Container(
    alignment: align,
      child:AnimatedDefaultTextStyle(
        style: index == current ? TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Color.fromRGBO(255, 255, 255, alpha)): TextStyle(fontSize: 32,color: Color.fromRGBO(255, 255, 255, alpha)),
        duration: Duration(milliseconds: 150),
        child: Text(list[index]),
      )
    )
  );
}
class myDate{
  List<String> months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  
  var now;
  myDate(){
    now = new DateTime.now();
  }
  getMonth(){
    return months[now.month-1]; 
  }
  getDay(){
    return now.day.toString();
  }
  List getMonthList(){
    return months;
  }
  int daysInMonth(DateTime date){
    var firstDayThisMonth = new DateTime(date.year,date.month,date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,firstDayThisMonth.month + 1,firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
  List getDayList(int month){
    DateTime temp = new DateTime(DateTime.now().year,month);
    int i = daysInMonth(temp);
    List<String> days = new List();
    for(var j = 1; j <= i; j++){
      days.add(j.toString());
    }
    return days;
  }
}
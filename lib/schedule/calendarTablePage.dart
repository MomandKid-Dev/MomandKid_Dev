import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

class calendarSchedule extends StatefulWidget{
  
  @override
  _calendarScheduleState createState() => _calendarScheduleState();
}

class _calendarScheduleState extends State<calendarSchedule>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFEFF5F8),

      // backgroundColor: Colors.transparent,
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

  @override
  Widget build(BuildContext context){
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
  }

  reverseAnimation() {
    controller.reverse(from: 1);
    print(animation.value);
    stateBloc.toggleAnimation();
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
          color: Colors.red),
      child: Column(
        children: <Widget>[
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:async';

class addSchedule extends StatefulWidget {


  @override
  _addScheduleState createState() => _addScheduleState();
}

class _addScheduleState extends State<addSchedule>{

  Color currentColor = Color(0xFF99B998);
  Color pickerColor = Color(0xFF99B998);
  List<Color> listColor = [Color(0xFF99B998),Color(0xFFF7DB4F),Color(0xFFFECEAB),Color(0xFFFF847C),Color(0xFFE84A5F),Color(0xFF6C5B7B),Color(0xFF45ADA8)];
  List<Color> listBGColor = [Color(0xFFDBECDB),Color(0xFFFEF0AC),Color(0xFFFFEFE3),Color(0xFFFFD4D1),Color(0xFFF8B3BC),Color(0xFFCCBFD8),Color(0xFFA6CECC)];
  List<String> _color = ['Default Color','1','2','3','4','5','6'];
  final TextEditingController textController = new TextEditingController();
  final TextEditingController notiController = new TextEditingController();
  final TextEditingController desController = new TextEditingController();
  
  void changeColor(Color color) => setState(() => pickerColor = color);

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
              Navigator.pop(context, [textController.text, notiController.text, currentColor, desController.text, listBGColor[listColor.indexOf(currentColor)]]);
            } 
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left:60, right: 40),
            child: TextField(
              controller: textController,
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
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left:12, right:40),
            child:TextField(
              controller: notiController,
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
                              availableColors: listColor,
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
                    _color[listColor.indexOf(currentColor)],
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
              controller: desController,
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
            )
          ),
        ],
      ),
    );
  }
}

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
                    onPressed: (){}
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
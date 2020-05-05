import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class addSchedule extends StatefulWidget {
  @override
  _addScheduleState createState() => _addScheduleState();
}

class _addScheduleState extends State<addSchedule> {
  Color currentColor = Color(0xFF99B998);
  Color pickerColor = Color(0xFF99B998);
  List<Color> listColor = [
    Color(0xFF99B998),
    Color(0xFFF7DB4F),
    Color(0xFFFECEAB),
    Color(0xFFFF847C),
    Color(0xFFE84A5F),
    Color(0xFF6C5B7B),
    Color(0xFF45ADA8)
  ];
  List<Color> listBGColor = [
    Color(0xFFDBECDB),
    Color(0xFFFEF0AC),
    Color(0xFFFFEFE3),
    Color(0xFFFFD4D1),
    Color(0xFFF8B3BC),
    Color(0xFFCCBFD8),
    Color(0xFFA6CECC)
  ];
  List<String> _color = [
    'Default Color',
    'Yellow color but brighter',
    'In Thai, this color called "สีเนื้อ"',
    'Orange color but more pastel',
    'Red color but in Thai, called "บานเย็น"',
    'Purple color but violet',
    'Blue color but a bit green'
  ];
  final TextEditingController textController = new TextEditingController();
  final TextEditingController desController = new TextEditingController();
  bool isNoti = false;
  String _date = 'Select Date and Time', _time = '';
  List<String> weekday = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  List<String> month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateTime _dateTimeSche;
  void changeColor(Color color) => setState(() => pickerColor = color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //131048
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.close),
            color: Color(0xFF131048),
            iconSize: 40,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(LineAwesomeIcons.paper_plane),
              color: Color(0xFF131048),
              iconSize: 40,
              onPressed: () {
                Navigator.pop(context, [
                  textController.text,
                  isNoti,
                  currentColor,
                  desController.text,
                  listBGColor[listColor.indexOf(currentColor)],
                  _dateTimeSche,
                  _time
                ]);
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 60, right: 40),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Add title',
                hintStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Prompt',
                    color: Color(0xFF8A88A4)),
                filled: false,
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt',
                  color: Color(0xFF131048)),
            ),
          ),
          Divider(),
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 25,
                ),
                Icon(
                  Icons.access_time,
                  color: Color(0xFF131048),
                  size: 30,
                ),
                SizedBox(
                  width: 7,
                ),
                FlatButton(
                    padding:
                        EdgeInsets.only(left: 2, right: 8, top: 8, bottom: 8),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2025, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('Confirm $date');
                        _dateTimeSche = date;
                        _date =
                            '${weekday[date.weekday - 1]}, ${month[date.month - 1]} ${date.day} ${date.year}';
                        if (date.hour > 9 && date.minute > 9)
                          _time = '${date.hour}:${date.minute}';
                        else if (date.hour > 9 && date.minute < 10)
                          _time = '${date.hour}:0${date.minute}';
                        else if (date.hour < 10 && date.minute > 9)
                          _time = '0${date.hour}:${date.minute}';
                        else if (date.hour < 10 && date.minute < 10)
                          _time = '0${date.hour}:0${date.minute}';
                        setState(() {});
                      });
                    },
                    child: Text(
                      _date,
                      style: TextStyle(fontSize: 16, color: Color(0xFF131048)),
                    )),
                Spacer(
                  flex: 8,
                ),
                Text(
                  _time,
                  style: TextStyle(fontSize: 16, color: Color(0xFF131048)),
                ),
                Spacer(flex: 5)
              ],
            ),
          ),
          Divider(),
          Container(
              padding: EdgeInsets.only(left: 12, right: 40), //Notification
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.notifications_none,
                    color: Color(0xFF131048),
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Notification',
                    style: TextStyle(fontSize: 16, color: Color(0xFF131048)),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Switch(
                      value: isNoti,
                      activeColor: Color(0xFF637470),
                      onChanged: (value) {
                        setState(() {
                          isNoti = value;
                        });
                      })
                ],
              )),
          Divider(),
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 13,
                ),
                Container(
                  height: 25,
                  width: 25,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: currentColor, shape: BoxShape.circle),
                ),
                FlatButton(
                    padding:
                        EdgeInsets.only(left: 2, right: 8, top: 8, bottom: 8),
                    onPressed: () {
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
                          });
                    },
                    child: Text(
                      _color[listColor.indexOf(currentColor)],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF131048),
                      ),
                    )),
              ],
            ),
          ),
          Divider(),
          Container(
              padding: EdgeInsets.only(left: 12, right: 40),
              child: TextField(
                controller: desController,
                decoration: InputDecoration(
                    hintText: 'Add description',
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Prompt',
                        color: Color(0xFF8A88A4)),
                    prefixIcon: Icon(
                      LineAwesomeIcons.comment,
                      color: Color(0xFF131048),
                      size: 30,
                    ),
                    filled: false,
                    border: InputBorder.none),
                style: TextStyle(color: Color(0xFF131048)),
              )),
        ],
      ),
    );
  }
}

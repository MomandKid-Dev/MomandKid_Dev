import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:momandkid/kids/healthMain.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';

class editKidData extends StatefulWidget {
  editKidData({this.index, this.data, this.userId, this.dataList});
  // String img,name;
  Map data;
  int index;
  String userId;
  dataTest dataList;
  @override
  _editState createState() => _editState();
}

class _editState extends State<editKidData> with TickerProviderStateMixin {
  TextEditingController nameController;
  TextEditingController weightController;
  TextEditingController heightController;

  Animation<Offset> slideAnimationBlur2;
  AnimationController slideController2;
  Animation<double> opaAnimationBlur2;
  String gender;
  int day, month, year;
  DateTime birthDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.data['name']);
    gender = widget.data['gender'];
    birthDate = widget.data['birthdate'];
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideAnimationBlur2 = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController2));
    opaAnimationBlur2 =
        Tween<double>(begin: 0, end: 10).animate(slideController2);
  }

  updateVaccineLog(DateTime birthDate, String babyId) {
    print('Vaccine');
    widget.dataList.getvaccineEdit(birthDate, babyId);
  }

  Future updateDevelopeLog(DateTime birthDate, String babyId) {
    print('Develope');
    return widget.dataList.getDevelopeEdit(birthDate, babyId);
  }

  updateDataDevice(String name, String gender, DateTime birthDate) {
    widget.data['name'] = name;
    widget.data['gender'] = gender;
    widget.data['birthdate'] = birthDate;
    widget.data['age'] =
        Age.dateDifference(fromDate: birthDate, toDate: DateTime.now());
  }

  updateDateFirebase(
      String babyId, String name, String gender, DateTime birthDate) async {
    await Database()
        .updateBaby(babyId, name, gender, Timestamp.fromDate(birthDate));
  }

  deleteDataFirebase(String babyId) {
    Database(userId: widget.userId).deleteBabyInfo(babyId).whenComplete(() {
      widget.dataList.kiddo.removeWhere((item) => item['kid'] == babyId);
      widget.dataList.kiddo[widget.dataList.kiddo.length - 1]['sel'] = 1;
      print('kiddo: ${widget.dataList.kiddo}');
      widget.dataList
          .getDataLogAll()
          .whenComplete(() => Navigator.pop(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    boldtext() => TextStyle(
        color: Color(0xff131048), fontWeight: FontWeight.bold, fontSize: 20);

    dialogBox(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: edgeAll(20),
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Male';
                          });

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: allRoundedCorner(30),
                            border: Border.all(
                                color: gender == 'Male'
                                    ? Colors.pink
                                    : Colors.grey),
                          ),
                          child: Text(
                            'Boy',
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Female';
                          });

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: allRoundedCorner(30),
                            border: Border.all(
                                color: gender == 'Female'
                                    ? Colors.pink
                                    : Colors.grey),
                          ),
                          child: Text(
                            'Girl',
                            style: TextStyle(fontSize: 15),
                          ),
                        ))
                  ],
                ),
              )));
    }

    calendarBox(BuildContext context) {
      return showDatePicker(
              context: context,
              initialDate: birthDate,
              firstDate: DateTime(birthDate.year - 5),
              lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .then((date) {
        setState(() {
          String newDate = '';
          if (date.day < 10) {
            newDate += '0${date.day.toString()}';
          } else {
            newDate += date.day.toString();
          }
          if (date.month < 10) {
            print(date.month);
            newDate += '0${date.month.toString()}';
          } else {
            newDate += date.month.toString();
          }

          newDate += date.year.toString();

          birthDate = date;
        });
      });
    }

    return Container(
        decoration: BoxDecoration(gradient: gradientBackground()),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height - 450,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    width: MediaQuery.of(context).size.width - 40,
                    padding: edgeLR(20),
                    decoration: BoxDecoration(
                        borderRadius: allRoundedCorner(20),
                        color: Colors.white),
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
                                          border: InputBorder.none))),
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
                                  margin: edgeTB(5), child: Text('Gender')),
                              GestureDetector(
                                  onTap: () {
                                    dialogBox(context);
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      margin: edgeTB(5),
                                      child: gender == 'Male'
                                          ? Text(
                                              'Boy',
                                              style: boldtext(),
                                            )
                                          : Text(
                                              'Girl',
                                              style: boldtext(),
                                            ))),
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
                                  onTap: () {
                                    calendarBox(context);
                                  },
                                  child: Container(
                                      margin: edgeTB(5),
                                      child: Text(
                                        toDate(birthDate),
                                        style: boldtext(),
                                      ))),
                              Divider(
                                height: 5,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print(nameController.text);
                            print('gender: ${gender}');
                            slideController2.forward();
                            updateDateFirebase(
                              widget.data['kid'],
                              nameController.text,
                              gender,
                              birthDate,
                            );
                            updateDataDevice(
                              nameController.text,
                              gender,
                              birthDate,
                            );

                            await updateVaccineLog(
                                birthDate, widget.data['kid']);
                            await updateDevelopeLog(
                                birthDate, widget.data['kid']);
                            // .whenComplete(() => Navigator.pop(context));

                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    borderRadius: allRoundedCorner(10),
                                    border:
                                        Border.all(color: Color(0xffE7E7EC))),
                                child: Text(
                                  'Save Change',
                                  style: TextStyle(color: Color(0xff625BD4)),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            // widget.data['name'] = nameController.text;
                            deleteDataFirebase(widget.data['kid']);
                          },
                          child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(

                                    // borderRadius: allRoundedCorner(20),
                                    // border: Border.all(color:Color(0xffE7E7EC))
                                    ),
                                child: Text(
                                  'Delete Profile',
                                  style: TextStyle(color: Color(0xff625BD4)),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 500,
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'child${widget.index}',
                        child: circleImg(
                          img: AssetImage('assets/icons/037-baby.png'),
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Text('eiei')
                    ],
                  ),
                ),
                //hear
                // Container(
                //   color: Colors.red,
                //   width: 200,
                //   height: 300,
                // )
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: SlideTransition(
                    position: slideAnimationBlur2,
                    child: blurTransition(
                      animation: opaAnimationBlur2,
                      controller: slideController2,
                    ),
                  ),
                )
              ],
            )));
  }
}

toDate(DateTime date) {
  String newDate = '';
  List month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  newDate += date.day.toString();
  newDate += ' ';
  newDate += month[date.month - 1];
  newDate += ' ';
  newDate += date.year.toString();
  return newDate;
}

toDateTime(String date) {
  DateTime newDate = DateTime(int.parse(date.substring(4, 8)),
      int.parse(date.substring(2, 4)), int.parse(date.substring(0, 2)));
  return newDate;
}

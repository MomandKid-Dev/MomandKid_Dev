import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/story/carousel.dart';

//start with this
class mainAddScreen extends StatefulWidget {
  mainAddScreen({this.userId, this.data});

  final String userId;
  dataTest data;
  @override
  _addScreenState createState() => _addScreenState();
}

class _addScreenState extends State<mainAddScreen> {
  @override
  Widget build(BuildContext context) {
    return _mainAddKid(
      child: _add(userId: widget.userId, data: widget.data),
    );
  }
}

class _mainAddKid extends StatefulWidget {
  Widget child;
  _mainAddKid({this.child});
  @override
  _mainAddState createState() => _mainAddState();
  static _mainAddState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedAddKid>()
              as _inheritedAddKid)
          .data;
}

class _mainAddState extends State<_mainAddKid> {
  PageController pageController;
  TextEditingController textController;
  TextEditingController weightController;
  TextEditingController heightController;
  int day, month, year;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      initialPage: 0,
    );
    textController = TextEditingController();
    weightController = TextEditingController(text: '0');
    heightController = TextEditingController(text: '0');
    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return _inheritedAddKid(
      child: widget.child,
      data: this,
    );
  }
}

class _inheritedAddKid extends InheritedWidget {
  _mainAddState data;

  _inheritedAddKid({@required Widget child, this.data}) : super(child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}

class _add extends StatefulWidget {
  _add({this.userId, this.data});

  final String userId;
  dataTest data;

  @override
  _addState createState() => _addState();
}

class _addState extends State<_add> {
  String _babyGender;

  double scale() {
    if (MediaQuery.of(context).size.width >= 400) {
      return 1.5;
    } else if (MediaQuery.of(context).size.width >= 300) {
      return 1;
    }
    return 1;
  }
  // callback(newMonth,newDay){
  //   setState(() {
  //     dayy = newDay;
  //     monthh = newMonth;

  //   });
  // }
  @override
  void initState() {
    _babyGender = "";
    // TODO: implement initState
    super.initState();
  }

  void confirmData() async {
    dynamic kid;
    Database(userId: widget.userId)
        .createBabyInfo(
            _mainAddKid.of(context).textController.text,
            _babyGender,
            Timestamp.fromDate(DateTime(_mainAddKid.of(context).year,
                _mainAddKid.of(context).month, _mainAddKid.of(context).day)),
            double.parse(_mainAddKid.of(context).heightController.text),
            double.parse(_mainAddKid.of(context).weightController.text),
            "image path")
        .then((val) {
      kid = val.documentID;
    }).whenComplete(() async {
      print('add');
      widget.data.getKiddo(widget.userId).whenComplete(() async {
        await widget.data.getVaccineListFirst(
            DateTime(_mainAddKid.of(context).year,
                _mainAddKid.of(context).month, _mainAddKid.of(context).day),
            kid);
        await widget.data.getDevelopeListFirst(
            DateTime(_mainAddKid.of(context).year,
                _mainAddKid.of(context).month, _mainAddKid.of(context).day),
            kid);

        print('kid: $kid');
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: edgeAll(0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffFF9AB3), Color(0xff9CCBFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Column(
              children: <Widget>[
                Container(
                    padding: edgeTB(10),
                    height: MediaQuery.of(context).size.height - 105,
                    child: PageView(
                      controller: _mainAddKid.of(context).pageController,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        page(
                          title: 'Nice to meet you! What is your baby name?',
                          children: <Widget>[
                            TextField(
                              maxLength: 50,
                              controller:
                                  _mainAddKid.of(context).textController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 20),
                                helperStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6)),
                                helperText: 'YOUR BABY NAME',
                                hintText: 'Baby Name...',
                              ),
                            )
                          ],
                        ),
                        page(
                          title: 'Next step, Your baby is...',
                          children: <Widget>[
                            Container(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _babyGender = 'Male';
                                        _mainAddKid
                                            .of(context)
                                            .pageController
                                            .nextPage(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOutExpo);
                                      },
                                      child: Container(
                                        padding: edgeLR(20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Icon(
                                          Icons.child_care,
                                          size: 80,
                                          color: Color(0xffB7CFF2),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _babyGender = 'Female';
                                          _mainAddKid
                                              .of(context)
                                              .pageController
                                              .nextPage(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOutExpo);
                                        },
                                        child: Container(
                                            padding: edgeLR(20),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Icon(
                                              Icons.child_care,
                                              size: 80,
                                              color: Color(0xffF5B0C3),
                                            ))),
                                    // TextFormField(
                                    //   controller: TextEditingController(text: 'eiei'),
                                    // )
                                  ],
                                ))
                          ],
                        ),
                        page(
                          title: 'Next step, what date is child born?',
                          children: <Widget>[
                            Container(
                                // alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime(
                                                  _mainAddKid.of(context).year,
                                                  _mainAddKid.of(context).month,
                                                  _mainAddKid.of(context).day),
                                              firstDate: DateTime(
                                                  DateTime.now().year - 1),
                                              lastDate: DateTime.now())
                                          .then((date) {
                                        //here
                                        setState(() {
                                          _mainAddKid.of(context).day =
                                              date.day;
                                          _mainAddKid.of(context).month =
                                              date.month;
                                          _mainAddKid.of(context).year =
                                              date.year;
                                        });
                                      });
                                    },
                                    child: Text(
                                      '${getMonth(_mainAddKid.of(context).month)}' +
                                          ' ${_mainAddKid.of(context).day}, ' +
                                          '${_mainAddKid.of(context).year}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20 * scale()),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  )
                                ]))
                          ],
                        ),
                        page(
                          title: 'Next step, what weight of child?',
                          children: <Widget>[
                            Container(
                              padding: edgeAll(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: allRoundedCorner(15)),
                              margin: edgeAll(20),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/icons/weight.png',
                                      width: 40 * scale()),
                                  Container(
                                    margin: edgeTB(10),
                                    child: Text(
                                      'Baby Weight',
                                      style: TextStyle(fontSize: 15 * scale()),
                                    ),
                                  ),
                                  Container(
                                    margin: edgeTB(10),
                                    child: Text(
                                      _mainAddKid
                                          .of(context)
                                          .weightController
                                          .text,
                                      style: TextStyle(fontSize: 25 * scale()),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Baby weight',
                                        style:
                                            TextStyle(fontSize: 15 * scale()),
                                      ),
                                      Container(
                                        height: 15 * scale(),
                                        width: 100,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: _mainAddKid
                                              .of(context)
                                              .weightController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            // if(_mainAddKid.of(context).weightController.text == ''){
                                            //   _mainAddKid.of(context).weightController.text = 0.toString();
                                            //   _mainAddKid.of(context).weightController.selection = TextSelection.collapsed(offset: _mainAddKid.of(context).weightController.text.length);
                                            // }
                                            // else if(text.length > 1){
                                            //   if(_mainAddKid.of(context).weightController.text.substring(0,1) == '0'){
                                            //     _mainAddKid.of(context).weightController.text = _mainAddKid.of(context).weightController.text.substring(1,_mainAddKid.of(context).weightController.text.length);
                                            //   }
                                            // }
                                            setState(() {});
                                          },
                                        ),
                                      )
                                      // Text('HERE',style: TextStyle(fontSize: 15 * scale()),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _mainAddKid.of(context).pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOutExpo);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: edgeAll(20),
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: allRoundedCorner(30)),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 12 * scale()),
                                ),
                              ),
                            )
                          ],
                        ),
                        page(
                          title: 'Next step, what height of child?',
                          children: <Widget>[
                            Container(
                              padding: edgeAll(20),
                              margin: edgeAll(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: allRoundedCorner(15)),
                              child: Column(
                                children: <Widget>[
                                  Image.asset('assets/icons/height.png',
                                      height: 40 * scale()),
                                  Container(
                                    margin: edgeTB(10),
                                    child: Text(
                                      'Baby Height',
                                      style: TextStyle(fontSize: 15 * scale()),
                                    ),
                                  ),
                                  Container(
                                    margin: edgeTB(10),
                                    child: Text(
                                      _mainAddKid
                                          .of(context)
                                          .heightController
                                          .text,
                                      style: TextStyle(fontSize: 25 * scale()),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Baby weight',
                                        style:
                                            TextStyle(fontSize: 15 * scale()),
                                      ),
                                      Container(
                                        height: 15 * scale(),
                                        width: 100,
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: _mainAddKid
                                              .of(context)
                                              .heightController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            if (_mainAddKid
                                                    .of(context)
                                                    .heightController
                                                    .text ==
                                                '') {
                                              _mainAddKid
                                                  .of(context)
                                                  .heightController
                                                  .text = 0.toString();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      )
                                      // Text('HERE',style: TextStyle(fontSize: 15 * scale()),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                confirmData();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: edgeAll(20),
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: allRoundedCorner(30)),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 12 * scale()),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Container(
                    padding: edgeLR(10),
                    alignment: Alignment.centerRight,
                    height: 80,
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _mainAddKid
                                    .of(context)
                                    .pageController
                                    .previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOutExpo);
                              },
                              child: Container(
                                height: 40,
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                _mainAddKid.of(context).pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOutExpo);
                                //here
                              },
                              child: Container(
                                height: 40,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              )),
                        ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class page extends StatefulWidget {
  String title;
  List<Widget> children;
  page({this.title, this.children});
  @override
  _pageState createState() => _pageState();
}

class _pageState extends State<page> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height:MediaQuery.of(context).size.height - 125,
        padding: edgeLR(20),
        child: Column(
          children: <Widget>[
            Expanded(
                // flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Image.asset(
                    'assets/icons/037-baby.png',
                    height: 80,
                    width: 80,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.children,
                  ))
                ])),
          ],
        ));
  }
}

getMonth(int index) {
  var month = [
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
  return month[index - 1];
}

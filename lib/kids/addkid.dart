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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      initialPage: 0,
    );
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
  TextEditingController _weight = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _name = TextEditingController();

  // Date
  int day = DateTime.now().day;
  int month = DateTime.now().month;

  callback(newMonth, newDay) {
    setState(() {
      day = newDay;
      month = newMonth;
    });
  }

  double _babyWeight;
  double _babyHeight;
  String _babyName;
  String _babyGender;

  @override
  void initState() {
    _babyWeight = 0;
    _babyHeight = 0;
    _babyName = "";
    _babyGender = "";
    super.initState();
  }

  void confirmData() async {
    await Database(userId: widget.userId).createBabyInfo(_babyName, _babyGender,
        Timestamp.now(), _babyHeight, _babyWeight, "image path");
    if (widget.data != null) {
      widget.data.getKiddo(widget.userId);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    height: MediaQuery.of(context).size.height - 190,
                    child: PageView(
                      controller: _mainAddKid.of(context).pageController,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        page(
                          title: '1',
                          children: <Widget>[
                            TextFormField(
                              maxLength: 50,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Baby Name',
                              ),
                              onChanged: (val) => _babyName = val,
                            )
                          ],
                        ),
                        page(
                          title: '2',
                          children: <Widget>[
                            carousel(
                              selectedDay: day,
                              selectedMonth: month,
                            )
                          ],
                        ),
                        page(
                          title: '3',
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                MaterialButton(
                                  height: 200,
                                  child: Icon(
                                    Icons.child_care,
                                    size: 80,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    _babyGender = 'Male';
                                    _mainAddKid
                                        .of(context)
                                        .pageController
                                        .nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOutExpo);
                                  },
                                ),
                                MaterialButton(
                                  height: 200,
                                  child: Icon(
                                    Icons.child_care,
                                    size: 80,
                                    color: Colors.pinkAccent,
                                  ),
                                  onPressed: () {
                                    _babyGender = 'Female';
                                    _mainAddKid
                                        .of(context)
                                        .pageController
                                        .nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOutExpo);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        page(
                          title: '4',
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              padding: edgeAll(20),
                              margin: edgeAll(20),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.account_box),
                                  Container(
                                    margin: edgeAll(20),
                                    child: Text('Baby Weight'),
                                  ),
                                  Container(
                                    margin: edgeAll(20),
                                    child: Text('$_babyWeight Kg'),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Baby weight'),
                                      Text('kg')
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _weight,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '${_babyWeight}',
                                        ),
                                        onEditingComplete: () {
                                          _babyWeight =
                                              double.parse(_weight.text);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: RaisedButton(
                                padding: edgeAll(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text('Confirm'),
                                onPressed: () {
                                  _mainAddKid
                                      .of(context)
                                      .pageController
                                      .nextPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOutExpo);
                                },
                              ),
                            )
                          ],
                        ),
                        page(
                          title: '5',
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              padding: edgeAll(20),
                              margin: edgeAll(20),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.account_box),
                                  Container(
                                    margin: edgeAll(20),
                                    child: Text('Baby Height'),
                                  ),
                                  Container(
                                    margin: edgeAll(20),
                                    child: Text('$_babyHeight cm'),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Baby weight'),
                                      Text('0kg')
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _height,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '$_babyHeight',
                                        ),
                                        onEditingComplete: () {
                                          _babyHeight =
                                              double.parse(_height.text);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: RaisedButton(
                                padding: edgeAll(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text('Confirm'),
                                onPressed: confirmData,
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Column(children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        _mainAddKid.of(context).pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutExpo);
                      },
                      child: Container(
                        height: 75,
                        child: Icon(Icons.arrow_upward),
                      )),
                  GestureDetector(
                      onTap: () {
                        _mainAddKid.of(context).pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutExpo);
                      },
                      child: Container(
                        height: 75,
                        child: Icon(Icons.arrow_downward),
                      )),
                ])
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
    return Column(
      children: <Widget>[
        Expanded(
            child: Column(
          children: <Widget>[Icon(Icons.access_alarm)] + widget.children,
        )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:momandkid/Profile/settingPage.dart';
import 'package:momandkid/services/database.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:momandkid/kids/addkid.dart';
//service
import 'package:momandkid/services/auth.dart';

import '../shared/circleImg.dart';

class mainProfile extends StatefulWidget {
  mainProfile({this.auth, this.logoutCallback, this.userId, this.data});

  final AuthService auth;
  final VoidCallback logoutCallback;
  final String userId;
  dataTest data;
  @override
  _mainProfileState createState() => _mainProfileState();
}

class _mainProfileState extends State<mainProfile> {
  dynamic info;

  getInfo() async {
    await Database(userId: widget.userId)
        .getUserData()
        .then((onValue) => info = onValue.data)
        .whenComplete(() {
      setState(() {
        print('done');
      });
    });
    kidsList = [];
    for (var i = 0; i <= widget.data.kiddo.length; i++) {
      if (i == widget.data.kiddo.length) {
        kidsList.add([2]);
      } else {
        kidsList.add([
          1,
          widget.data.kiddo[i]['image'],
          widget.data.kiddo[i]['name'],
          '${widget.data.kiddo[i]['birthdate'].day}  ${month[widget.data.kiddo[i]['birthdate'].month - 1]} ${widget.data.kiddo[i]['birthdate'].year}'
        ]);
      }
    }
  }

  List month = [
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
  List kidsList = [];
  @override
  void initState() {
    getInfo();
    print('hello world');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data.kiddo.length);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFFFE2F1), Color(0xFFE9F2FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 30),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  size: 30, color: Color(0xFF131048)),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFFFBD7E6),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(24))),
                          child: IconButton(
                              icon: Icon(
                                Icons.menu,
                                size: 36,
                                color: Color(0xFF131048),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageRouteTransition(
                                        animationType:
                                            AnimationType.slide_right,
                                        builder: (context) => settingPage(
                                              userId: widget.userId,
                                              auth: widget.auth,
                                              logoutCallback:
                                                  widget.logoutCallback,
                                              info: info,
                                            )));
                              }),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFFFBBBCD), width: 8)),
                            child: ((info == null) ||
                                    (info['image'] == null) ||
                                    (info['image'] == '') ||
                                    (info['image'] == 'image path'))
                                ? Icon(
                                    Icons.person_outline,
                                    color: Color(0xFFFBBBCD),
                                    size: 80,
                                  )
                                : circleImg(img: NetworkImage(info['image']))),
                        Container(
                          width: 235,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(36)),
                              color: Color(0xFFFBD7E6)),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment(0.65, 0),
                                child: Icon(
                                  Icons.child_care,
                                  color: Color(0xFFFAD0E0),
                                  size: 95,
                                ),
                              ),
                              Align(
                                alignment: Alignment(-0.65, 0),
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xFFFAD0E0),
                                  size: 90,
                                ),
                              ),
                              Align(
                                  alignment: Alignment(0.42, -0.5),
                                  child: Text(
                                    info == null
                                        ? '0'
                                        : '${info['amount-baby']}',
                                    style: TextStyle(
                                        color: Color(0xFF131048),
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Align(
                                  alignment: Alignment(-0.42, -0.5),
                                  child: Text(
                                    info == null
                                        ? '0'
                                        : '${info['amount-story']}',
                                    style: TextStyle(
                                        color: Color(0xFF131048),
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Align(
                                  alignment: Alignment(0.5, 0.65),
                                  child: Text(
                                    'Baby',
                                    style: TextStyle(
                                      color: Color(0xFF131048),
                                      fontSize: 16,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment(-0.44, 0.65),
                                  child: Text(
                                    'Story',
                                    style: TextStyle(
                                      color: Color(0xFF131048),
                                      fontSize: 16,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(-1, -0.4),
                    child: Text(
                      info == null ? '' : '${info['name']}',
                      style: TextStyle(color: Color(0xFF131048), fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, 0.6),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: kidsList.length,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 4),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return kidsList[index][0] == 1
                        ? Container(
                            width: MediaQuery.of(context).size.width / 1.75,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Color(0xFFF89EB9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              child: RawMaterialButton(
                                onPressed: () {
                                  widget.data.setSelectedKid(index + 1);
                                  Navigator.pop(context, [2]);
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment(0, -0.35),
                                        child: Container(
                                          width: 110,
                                          height: 110,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFFCE3F2)),
                                          child: ((kidsList[index][1] == null) || (kidsList[index][1] == 'image path') || (kidsList[index][1] == '')) ?
                                            circleImg(img: AssetImage('assets/icons/037-baby.png')) :
                                            circleImg(img: NetworkImage(kidsList[index][1]))
                                        )),
                                    Align(
                                      alignment: Alignment(0, 0.4),
                                      child: Text(
                                        kidsList[index][2],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment(0, 0.465),
                                        child: Container(
                                          width: 120,
                                          height: 2,
                                          color: Colors.white,
                                        )),
                                    Align(
                                      alignment: Alignment(0, 0.6),
                                      child: Text(
                                        kidsList[index][3],
                                        style: TextStyle(
                                            color: Color(0xFFFCD8E3), //fcd8e3
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        : Container(
                            width: MediaQuery.of(context).size.width / 1.75,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Color(0xFFF89EB9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              child: RawMaterialButton(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => mainAddScreen(
                                                userId: widget.userId,
                                                data: widget.data,
                                              )));
                                  getInfo();
                                  print('on pressed');
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment(0, -0.25),
                                        child: Icon(
                                          Icons.child_care,
                                          color: Colors.white,
                                          size: 110,
                                        )),
                                    Align(
                                      alignment: Alignment(0, 0.25),
                                      child: Text(
                                        'ADD BABY',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

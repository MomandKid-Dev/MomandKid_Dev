import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/addkid.dart';
import 'package:momandkid/kids/card.dart';
import 'package:momandkid/kids/editKidData.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';
import 'dart:math' as math;
import '../shared/appbar.dart';
import 'DataTest.dart';
import 'health.dart';

class mainKidScreen extends StatefulWidget {
  mainKidScreen({this.userId, this.data});

  final String userId;
  dataTest data;

  @override
  _mainKidScreenState createState() => _mainKidScreenState();
}

class _mainKidScreenState extends State<mainKidScreen> {
  @override
  Widget build(BuildContext context) {
    return _kids(
        child: healthMain(userId: widget.userId, data: widget.data),
        data: widget.data);
  }
}

class _kids extends StatefulWidget {
  final Widget child;
  dataTest data;
  _kids({@required this.child, this.data});

  static _kidsState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedKids>()
              as _inheritedKids)
          .data;
  @override
  _kidsState createState() => _kidsState();
}

class _kidsState extends State<_kids> with TickerProviderStateMixin {
  bool open = false;
  dataTest data;
  bool loading = true;
  Animation<Offset> slideAnimationBlur2;
  AnimationController slideController2;
  Animation<double> opaAnimationBlur2;
  int kidsCount;
  loaded() {
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    data = widget.data;
    data.getDataLogAll().whenComplete(() {
      if (!mounted) return;
      loaded();
    });
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideAnimationBlur2 = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController2));
    opaAnimationBlur2 =
        Tween<double>(begin: 10, end: 0).animate(slideController2);

    super.initState();
  }

  setTrue() {
    setState(() {
      this.open = true;
    });
  }

  setFalse() {
    setState(() {
      this.open = false;
    });
  }

  setSelectedKid(int id) {
    setState(() {
      loading = true;
      data.setSelectedKid(id);
    });
    data.getDataLogAll().whenComplete(() => loaded());
  }

  getSelectedKid() {
    setState(() {
      data.getSelectedKid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _inheritedKids(
      data: this,
      child: widget.child,
    );
  }
}

class _inheritedKids extends InheritedWidget {
  final _kidsState data;
  const _inheritedKids({@required this.data, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class healthMain extends StatefulWidget {
  healthMain({this.userId, this.data});

  final String userId;
  dataTest data;
  bool open = false;
  @override
  _healthMainState createState() => _healthMainState();
}

class _healthMainState extends State<healthMain> with TickerProviderStateMixin {
  AnimationController slideController;
  AnimationController slideControllerBlur;
  AnimationController opaControllerBlur;
  Animation<Offset> slideAnimation;
  Animation<Offset> slideAnimationBlur;
  Animation<double> opaAnimationBlur;
  Animation<Offset> slideAnimationBlur2;
  AnimationController slideController2;
  Animation<double> opaAnimationBlur2;
  ScrollController scrollController;

  int kidsCount;
  makAnimationController(int duration) {
    return new AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));
  }

  @override
  void initState() {
    super.initState();
    slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideControllerBlur =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    opaControllerBlur =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    //Drop Down
    slideAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController));
    slideAnimationBlur = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController));
    slideAnimationBlur2 = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController2));
    opaAnimationBlur2 =
        Tween<double>(begin: 10, end: 0).animate(slideController2);
    opaAnimationBlur =
        Tween<double>(begin: 0, end: 10).animate(slideController);
  }

  @override
  void dispose() {
    super.dispose();
    slideController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.data = _kids.of(context).data;
    print('selected kid: ${widget.data.getSelectedKid()}');
    kidsCount = widget.data.kiddo.length;
    if (opaAnimationBlur.value != 0) {
      setState(() {
        widget.open = true;
      });
    } else {
      setState(() {
        widget.open = false;
      });
    }

    if (!_kids.of(context).loading)
      _kids.of(context).slideController2.forward();

    return Stack(children: <Widget>[
      Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 100,
              child: appBar(
                data: _kids.of(context).data,
                userId: widget.userId,
                kid: widget.data.getSelectedKid(),
                open: _kids.of(context).open,
                onTap: () {
                  if (_kids.of(context).open) {
                    slideController.reverse();
                    _kids.of(context).setFalse();
                  } else {
                    slideController.forward();
                    _kids.of(context).setTrue();
                  }
                },
              ),
            ),
            ClipRect(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height - 186,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            margin: EdgeInsets.only(top: 50),
                            constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xffFFE2F1),
                                      Color(0xffE9F2FF)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                          ),
                          ListView(
                              physics: BouncingScrollPhysics(),
                              padding: edgeAll(0),
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            list(context, widget.data, 'weight',
                                                widget.userId),
                                            list(context, widget.data, 'height',
                                                widget.userId)
                                          ],
                                        ),
                                      ),
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          badge(context, widget.data, 'vac'),
                                          badge(context, widget.data, 'med'),
                                          badge(context, widget.data, 'evo'),
                                        ],
                                      )),
                                      Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: widget.data
                                                      .getRecent()
                                                      .length >
                                                  0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                      Text(
                                                        '  Recent actions',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Color(
                                                                0xff131048),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      recent(
                                                          context, widget.data),
                                                    ])
                                              : null),
                                    ],
                                  ),
                                ),
                              ]),
                          SlideTransition(
                            position: slideAnimationBlur,
                            child: blurTransition(
                              animation: opaAnimationBlur,
                              controller: slideController,
                            ),
                          ),
                          SlideTransition(
                            position: slideAnimation,
                            child: Container(
                                height: (kidsCount + 1) * 90.0,
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height -
                                            150),
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: ListView.builder(
                                  padding: edgeAll(0),
                                  //childrenList
                                  physics: BouncingScrollPhysics(),
                                  itemCount: kidsCount + 1,
                                  itemBuilder: (_, i) {
                                    if (i == kidsCount) {
                                      return GestureDetector(
                                          onTap: () async {
                                            //Add dek here
                                            int temp = kidsCount;
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        mainAddScreen(
                                                          userId: widget.userId,
                                                          data: widget.data,
                                                        ))).whenComplete(() {
                                              kidsCount =
                                                  widget.data.kiddo.length;
                                              _kids
                                                  .of(context)
                                                  .setSelectedKid(kidsCount);
                                            });
                                          },
                                          child: Container(
                                            height: 83,
                                            width: 200,
                                            margin: edgeLR(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  allRoundedCorner(15),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xff131048)
                                                      .withOpacity(0.2)),
                                              // color: Colors.red
                                            ),
                                            alignment: Alignment.center,
                                            child: Text('Add Kid',
                                                style: TextStyle(
                                                    color: Color(0xff131048),
                                                    fontSize: 18)),
                                          ));
                                    }

                                    return childrenList(
                                      index: i,
                                      img: widget.data.getKids()[i]['image'],
                                      name: widget.data.getKids()[i]['name'],
                                      controller: slideController,
                                      data: _kids.of(context).data,
                                      userId: widget.userId,
                                    );
                                  },
                                )),
                          ),
                        ],
                      ))),
            )
          ],
        ),
      ),
      SlideTransition(
        position: _kids.of(context).slideAnimationBlur2,
        child: blurTransition(
          animation: _kids.of(context).opaAnimationBlur2,
          controller: _kids.of(context).slideController2,
        ),
      ),
    ]);
  }
}

list(BuildContext context, dataTest data, String type, String userId) {
  String textType;
  String unit;
  String img;
  if (type == 'weight') {
    textType = 'weight';
    unit = 'kg';
  } else {
    textType = 'height';
    unit = 'cm';
  }
  if (type == 'weight')
    img = 'assets/icons/weight-alt.png';
  else
    img = 'assets/icons/male.png';
  return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => health(
                  userId: userId,
                  data: data,
                  type: type,
                ));
        Navigator.push(context, route);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(type), Image.asset(img)],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      _kids.of(context).data.getSelectedKid()[textType] != null
                          ? <Widget>[
                              Text(
                                  '${_kids.of(context).data.getSelectedKid()[textType]} ${unit}')
                            ]
                          : <Widget>[Text('No data yet')],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.getStandardColor(type)),
                  ),
                  Text(data.getStandardText(type))
                ],
              ),
            )
          ],
        ),
      ));
}

badge(BuildContext context, dataTest data, String type) {
  return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => health(
                  data: data,
                  type: type,
                ));
        Navigator.push(context, route);
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 3.6,
        width: MediaQuery.of(context).size.width / 3.6,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(data.getImg(type)),
              width: MediaQuery.of(context).size.width / 10,
              height: MediaQuery.of(context).size.width / 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.getTitle(type),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 30),
                  )
                ],
              ),
            )
          ],
        ),
      ));
}

Widget recent(BuildContext context, dataTest data) => Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
          children: data
              .getRecent()
              .map<Widget>((e) => cards(context, data, e['type'], e))
              .toList()),
    );

class childrenList extends StatefulWidget {
  childrenList(
      {this.index,
      this.img,
      this.name,
      this.controller,
      this.data,
      this.userId});
  String img, name;
  String userId;
  int index;
  bool open;
  dataTest data;
  AnimationController controller;
  @override
  _childrenListState createState() => _childrenListState();
}

class _childrenListState extends State<childrenList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: edgeAll(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: GestureDetector(
                onTap: () {
                  _kids.of(context).setFalse();
                  widget.controller.reverse();

                  _kids.of(context).setSelectedKid(widget.index + 1);
                  _kids.of(context).slideController2.reverse();
                  if (!_kids.of(context).loading)
                    _kids.of(context).slideController2.forward();
                },
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: 'child${widget.index}',
                      child: circleImg(
                        img: ((widget.img == null) |
                                (widget.img == 'image path'))
                            ? AssetImage('assets/icons/037-baby.png')
                            : NetworkImage(widget.img),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(
                      '   ' + widget.name,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class blurTransition extends AnimatedWidget {
  Animation<double> animation;
  AnimationController controller;
  bool open;
  blurTransition({this.animation, this.controller, this.open})
      : super(
          listenable: animation,
        );
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
        child: GestureDetector(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
            )));
  }
}

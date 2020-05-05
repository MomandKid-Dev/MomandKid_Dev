import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/healthCard.dart';
import 'package:momandkid/shared/style.dart';
import 'appBar.dart';
import 'card.dart';
import 'DataTest.dart';
import 'dart:math' as math;

class health extends StatefulWidget {
  health({this.data, this.type, this.userId});

  dataTest data;
  bool pushed = false;
  String userId;
  String type;
  int color = 0;
  var color0;
  var color1;
  var color2;
  @override
  _healthState createState() => _healthState();
}

class _healthState extends State<health> {
  PageController pageController;

  @override
  void initState() {
    widget.color0 = Colors.white;
    widget.color1 = Colors.amber[600];
    widget.color2 = Colors.white;
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(255, 226, 241, 1),
                  Color.fromRGBO(233, 242, 255, 1)
                ])),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      delegate: appBarH(
                          maxHeight: 100,
                          minHeight: 100,
                          data: widget.data,
                          type: widget.type,
                          userId: widget.userId),
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 150,
                          ),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment:
                                widget.data.getData(widget.type).length > 0
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                            children: <Widget>[
                              isEvo(
                                  type: widget.type,
                                  pageController: pageController,
                                  page: pageController.hasClients
                                      ? pageController.page
                                      : 1),
                              Container(
                                  height: widget.type == 'evo'
                                      ? MediaQuery.of(context).size.height - 260
                                      : MediaQuery.of(context).size.height -
                                          100,
                                  width: MediaQuery.of(context).size.width,
                                  child: PageView(
                                      controller: pageController,
                                      physics: BouncingScrollPhysics(),
                                      children: widget.type == 'evo'
                                          ? <Widget>[
                                              ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  padding: EdgeInsets.all(0),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Column(
                                                        children: widget.data
                                                                    .getDataWithType(
                                                                        widget
                                                                            .type,
                                                                        0)
                                                                    .length >
                                                                0
                                                            ? widget.data
                                                                .getDataWithType(
                                                                    widget.type,
                                                                    0)
                                                                .map(
                                                                    (e) => card(
                                                                          data:
                                                                              widget.data,
                                                                          type:
                                                                              widget.type,
                                                                          list:
                                                                              e,
                                                                        ))
                                                                .toList()
                                                            : <Widget>[
                                                                Image.asset(
                                                                    'assets/icons/clock.png'),
                                                                Text(
                                                                  'ยังไม่มีการบันทึกข้อมูล',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                )
                                                              ],
                                                      ),
                                                    ),
                                                  ]),
                                              ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  padding: EdgeInsets.all(0),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Column(
                                                        children: widget.data
                                                                    .getDataWithType(
                                                                        widget
                                                                            .type,
                                                                        1)
                                                                    .length >
                                                                0
                                                            ? widget.data
                                                                .getDataWithType(
                                                                    widget.type,
                                                                    1)
                                                                .map(
                                                                    (e) => card(
                                                                          data:
                                                                              widget.data,
                                                                          type:
                                                                              widget.type,
                                                                          list:
                                                                              e,
                                                                        ))
                                                                .toList()
                                                            : <Widget>[
                                                                Image.asset(
                                                                    'assets/icons/clock.png'),
                                                                Text(
                                                                  'ยังไม่มีการบันทึกข้อมูล',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                )
                                                              ],
                                                      ),
                                                    )
                                                  ]),
                                              ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  padding: EdgeInsets.all(0),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Column(
                                                        children: widget.data
                                                                    .getDataWithType(
                                                                        widget
                                                                            .type,
                                                                        2)
                                                                    .length >
                                                                0
                                                            ? widget.data
                                                                .getDataWithType(
                                                                    widget.type,
                                                                    2)
                                                                .map(
                                                                    (e) => card(
                                                                          data:
                                                                              widget.data,
                                                                          type:
                                                                              widget.type,
                                                                          list:
                                                                              e,
                                                                        ))
                                                                .toList()
                                                            : <Widget>[
                                                                Image.asset(
                                                                    'assets/icons/clock.png'),
                                                                Text(
                                                                  'ยังไม่มีการบันทึกข้อมูล',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                )
                                                              ],
                                                      ),
                                                    )
                                                  ])
                                            ]
                                          : <Widget>[
                                              ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Column(
                                                        children: widget.data
                                                                    .getData(
                                                                        widget
                                                                            .type)
                                                                    .length >
                                                                0
                                                            ? widget.data
                                                                .getData(
                                                                    widget.type)
                                                                .map(
                                                                    (e) => card(
                                                                          data:
                                                                              widget.data,
                                                                          type:
                                                                              widget.type,
                                                                          list:
                                                                              e,
                                                                        ))
                                                                .toList()
                                                            : <Widget>[
                                                                Image.asset(
                                                                    'assets/icons/clock.png'),
                                                                Text(
                                                                  'ยังไม่มีการบันทึกข้อมูล',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                )
                                                              ],
                                                      ),
                                                    )
                                                  ])
                                            ]))
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ))));
  }
}

class appBarH extends SliverPersistentHeaderDelegate {
  appBarH({this.maxHeight, this.minHeight, this.data, this.type, this.userId});
  final double maxHeight, minHeight;
  String title, img, type;
  dataTest data;
  String userId;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    title = data.getTitle(type);
    img = data.getImg(type);
    var addButton;
    if ((title == 'พัฒนาการ') | (title == 'วัคซีน')) {
      addButton = null;
    } else {
      addButton = Icon(
        Icons.add_circle_outline,
        size: 40,
      );
    }
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 1, spreadRadius: 0.1, color: Color(0xff999999))
            ]),
        height: 100,
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: MaterialButton(
                      child: Image.asset(
                        'assets/icons/backButton.png',
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Image(
                          image: AssetImage(img),
                          width: 33,
                          height: 33,
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ))),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: MaterialButton(
                      child: addButton,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => editCard(
                                      userId: userId,
                                      data: data,
                                      type: type,
                                    )));
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class isEvo extends StatefulWidget {
  isEvo({this.type, this.pageController, this.page});
  Key key;
  String type;
  PageController pageController;
  var color0 = Colors.white;
  var color1 = Colors.amber[600];
  var color2 = Colors.white;
  double page;

  _isEvoState createState() => _isEvoState();
}

class _isEvoState extends State<isEvo> {
  Widget build(BuildContext context) {
    if (widget.page == 1) {
      widget.color0 = Colors.white;
      widget.color1 = Colors.amber[600];
      widget.color2 = Colors.white;
    } else if (widget.page == 0) {
      widget.color1 = Colors.white;
      widget.color0 = Color(0xff57c77c);
      widget.color2 = Colors.white;
    } else {
      widget.color0 = Colors.white;
      widget.color2 = Colors.redAccent;
      widget.color1 = Colors.white;
    }
    if (widget.type == 'evo') {
      return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                widget.pageController.animateToPage(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOutExpo);
                setState(() {
                  widget.page = 0;
                  widget.color0 = Color(0xff57c77c);
                  widget.color1 = Colors.white;
                  widget.color2 = Colors.white;
                });
              },
              child: Container(
                  height: MediaQuery.of(context).size.width / 3.6,
                  width: MediaQuery.of(context).size.width / 3.6,
                  decoration: BoxDecoration(
                      color: widget.color0, borderRadius: allRoundedCorner(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/grin-wink.png',
                        color: widget.color0 == Color(0xff57c77c)
                            ? Colors.white
                            : Color(0xff57c77c),
                      ),
                      Text(
                        'ตามเกณฑ์',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 26,
                            color: widget.color0 == Color(0xff57c77c)
                                ? Colors.white
                                : Color(0xff57c77c)),
                      )
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                widget.pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOutExpo);
                setState(() {
                  widget.page = 1;
                  widget.color1 = Colors.amber[600];
                  widget.color0 = Colors.white;
                  widget.color2 = Colors.white;
                });
              },
              child: Container(
                  height: MediaQuery.of(context).size.width / 3.6,
                  width: MediaQuery.of(context).size.width / 3.6,
                  decoration: BoxDecoration(
                      color: widget.color1, borderRadius: allRoundedCorner(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/meh.png',
                        color: widget.color1 == Colors.amber[600]
                            ? Colors.white
                            : Colors.amber[600],
                      ),
                      Text('ต้องฝึกฝน',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 26,
                            color: widget.color1 == Colors.amber[600]
                                ? Colors.white
                                : Colors.amber[600],
                          ))
                    ],
                  )),
            ),
            GestureDetector(
                onTap: () {
                  widget.pageController.animateToPage(2,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOutExpo);
                  setState(() {
                    widget.page = 2;
                    widget.color2 = Colors.redAccent;
                    widget.color1 = Colors.white;
                    widget.color0 = Colors.white;
                  });
                },
                child: Container(
                    height: MediaQuery.of(context).size.width / 3.6,
                    width: MediaQuery.of(context).size.width / 3.6,
                    decoration: BoxDecoration(
                        color: widget.color2,
                        borderRadius: allRoundedCorner(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/icons/sad-cry.png',
                            color: widget.color2 == Colors.redAccent
                                ? Colors.white
                                : Colors.redAccent),
                        Text('ช้ากว่าเกณฑ์',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 26,
                              color: widget.color2 == Colors.redAccent
                                  ? Colors.white
                                  : Colors.redAccent,
                            ))
                      ],
                    )))
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/addkid.dart';
import 'package:momandkid/kids/card.dart';
import 'package:momandkid/kids/editKidData.dart';
// import 'package:momandkid/shared/appbar.dart';
// import 'appBar.dart';
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
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // kidsCount = data.kiddo.length;
    data = widget.data;
    data.getDataLogAll().whenComplete(() => loaded());
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
    // TODO: implement updateShouldNotify
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
    // TODO: implement initState
    super.initState();
    slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideControllerBlur =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    opaControllerBlur =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    //Slide Page Down
    // slideAnimation = Tween<Offset>(begin: Offset(0,0),end: Offset(0,0.7)).animate(CurvedAnimation(curve: Curves.easeInOutExpo,parent: slideController));
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
    // slideController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    slideController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('data ${_kids.of(context).data}');
    widget.data = _kids.of(context).data;
    print('selected kid: ${widget.data.getSelectedKid()}');
    kidsCount = widget.data.kiddo.length;
    // kidsCount = widget.data.getKids().length;
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
        // backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 100,
              child: appBar(
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
              // pinned: true,
            ),
            ClipRect(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height - 186,
                  // height: MediaQuery.of(context).size.height - 150,
                  // color: Colors.red,
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
                                  //childrenList\
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
                                      img: widget.data.getKids()[i]['img'],
                                      name: widget.data.getKids()[i]['name'],
                                      controller: slideController,
                                      data: _kids.of(context).data,
                                      userId: widget.userId,
                                    );
                                  },
                                  // children:<Widget>[childrenList(img: 'assets/icons/037-baby.png',name: 'nackkie',controller: slideController,)]
                                )),
                          ),
                        ],
                      )
                      // child: ListView(
                      //   physics: BouncingScrollPhysics(),
                      //   padding: EdgeInsets.only(top:0),
                      //   children: <Widget>[

                      //   ],
                      // ),
                      )),
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
// class appBar extends StatefulWidget{
//   bool open;
//   Map kid;
//   AnimationController controller,blurController,opaController;
//   Animation<Offset> animation;
//   appBar({this.animation,this.controller,this.open,@required this.kid});
//   @override
//   _appBarState createState() => _appBarState();
// }

// class _appBarState extends State<appBar>{
//   // final double maxHeight, minHeight;

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return LayoutBuilder(
//       builder: (context, constraints){
//         var img,name,age;
//         if(_kids.of(context).data.getSelectedKid()!= null && _kids.of(context).data.getSelectedKid()!= []){
//           img = _kids.of(context).data.getSelectedKid()['img'];
//           name = _kids.of(context).data.getSelectedKid()['name'];
//           age = _kids.of(context).data.getSelectedKid()['age'];
//         }
//         return Stack(
//           children: <Widget>[
//             Container(
//               height: 150,
//               color: Colors.white,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: (){
//                       if(_kids.of(context).open){
//                         widget.controller.reverse();

//                         _kids.of(context).setFalse();
//                       }
//                       else{
//                         _kids.of(context).setTrue();
//                         widget.controller.forward();

//                       }
//                     },
//                     child:Container(
//                       height: 150,
//                       color: Colors.white,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.only(right:20),
//                             height: 80,
//                             width: 80,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(0xffFCE3F2),
//                               image: DecorationImage(
//                                 image: img == null ? AssetImage('assets/icons/037-baby.png'): AssetImage('assets/icons/${_kids.of(context).data.getSelectedKid()['img']}'),
//                                 fit: BoxFit.cover
//                               )
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(right: 20),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(name == null ? 'No kids' : name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
//                                 Text(age == null ? 'No data' : age,style: TextStyle(fontSize: 12),)
//                               ],
//                             ),
//                           ),

//                             Container(
//                               height: 16,
//                               child:ClipRect(
//                                 child: Stack(
//                                   children:<Widget>[
//                                     SlideTransition(
//                                     position: widget.animation,
//                                     child: Image.asset('assets/icons/hide.png',),
//                                       // Container(
//                                       //   margin: EdgeInsets.only(top:16),
//                                       //   child: Image.asset('assets/icons/expand.png'),
//                                       // ),
//                                     ),
//                                     SlideTransition(
//                                     position: widget.animation,
//                                     child:
//                                       Transform.translate(
//                                         offset: Offset(0,16),
//                                         child: Image.asset('assets/icons/expand.png'),
//                                       ),
//                                     )

//                                   ]
//                                 )
//                               ),
//                             )

//                         ],
//                       ),
//                     ),
//                   )
//                 ]
//               )
//             ),

//           ],
//         );
//       },
//     );
//   }

// }

list(BuildContext context, dataTest data, String type, String userId) {
  // data.getData()[0][0]['a']);

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
        // height: 200,
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
              // color: Colors.red,
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
              // padding: EdgeInsets.all(5),
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

// Widget cards(BuildContext context, dataTest data, String type) =>
//     new GestureDetector(
//         onTap: () {
//           // data.setRecent(list['id']);
//           // 'This is recent ${data.getRecent()}');
//           // Route route = MaterialPageRoute(builder: (context) => healthCard(data: data,type: type,list: list,));
//           // Navigator.push(context, route);
//         },
//         child: Container(
//           color: Colors.white,
//           padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),

//           // color: Colors.red,
//           // height: ,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(right: 10),
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         // color: Colors.red,
//                         border: Border.all(width: 0.3),
//                         image: DecorationImage(
//                           fit: BoxFit.fill,
//                           image: AssetImage('${data.getImg(type)}'),
//                         )),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: data.getSubval(type) == ''
//                         ? <Widget>[
//                             Text('${data.getVal(type)}'),
//                           ]
//                         : <Widget>[
//                             Text('${data.getVal(type)}'),
//                             Text('${data.getSubval(type)}')
//                           ],
//                   )
//                 ],
//               ),
//               Text('อายุ ${data.getAge()} เดือน')
//             ],
//           ),
//         ));

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

                  // _kids.of(context).data.kiddo);
                  _kids.of(context).setSelectedKid(widget.index + 1);
                  _kids.of(context).slideController2.reverse();
                  if (!_kids.of(context).loading)
                    _kids.of(context).slideController2.forward();

                  // widget.data.setSelectedKid(widget.index);
                  //push new kid use push replacement
                },
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: 'child${widget.index}',
                      child: circleImg(
                        img: AssetImage('assets/icons/037-baby.png'),
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
          GestureDetector(
            onTap: () async {
              var remove = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => editKidData(
                            index: widget.index,
                            data: widget.data.getKids()[widget.index],
                            userId: widget.userId,
                            dataList: widget.data,
                          )));
              if (remove == null) {
                null;
              } else {
                setState(() {
                  widget.data.getKids().removeAt(widget.index);

                  widget.data.setSelectedKidAny();
                  // widget.data.getSelectedKid());
                });
                // widget.data.getKids().removeAt(widget.index);
              }
            },
            child: Icon(Icons.edit),
          )
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

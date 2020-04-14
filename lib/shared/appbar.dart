import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:momandkid/shared/circleImg.dart';

typedef OnTap = void Function();

class appBar extends StatefulWidget {
  bool open;
  Map kid;
  OnTap onTap;

  appBar({this.open, @required this.kid, this.onTap});
  @override
  _appBarState createState() => _appBarState();
}

class _appBarState extends State<appBar> with TickerProviderStateMixin {
  // final double maxHeight, minHeight;
  AnimationController controller, blurController, opaController;
  Animation<Offset> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
        CurvedAnimation(curve: Curves.easeInOutExpo, parent: controller));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('show kid ${widget.kid}');
    // TODO: implement build
    return LayoutBuilder(
      builder: (context, constraints) {
        img() {
          if ((widget.kid == null)) {
            return AssetImage('assets/icons/404.png');
          } else if ((widget.kid['img'] == null)) {
            return AssetImage('assets/icons/404.png');
          }
          return AssetImage('assets/icons/${widget.kid['img']}');
        }

        name() {
          if ((widget.kid == null)) {
            return Text(
              'Null',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            );
          } else if ((widget.kid['name'] == null)) {
            return Text(
              'Null',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            );
          }
          return Text(
            widget.kid['name'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          );
        }

        age() {
          if ((widget.kid == null)) {
            return Text(
              'Null',
              style: TextStyle(fontSize: 12),
            );
          } else if (widget.kid['age'] == null) {
            return Text(
              'Null',
              style: TextStyle(fontSize: 12),
            );
          }
          return Text(
            widget.kid['age'],
            style: TextStyle(fontSize: 12),
          );
        }

        // if(_kids.of(context).data.getSelectedKid()!= null && _kids.of(context).data.getSelectedKid()!= []){
        //   img = _kids.of(context).data.getSelectedKid()['img'];
        //   name = _kids.of(context).data.getSelectedKid()['name'];
        //   age = _kids.of(context).data.getSelectedKid()['age'];
        // }
        return Stack(
          children: <Widget>[
            Container(
                height: 100,
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (widget.open != null) {
                            if (widget.open) {
                              controller.reverse();
                            } else {
                              controller.forward();
                            }
                          }
                          widget.onTap();
                          // if(_kids.of(context).open){
                          //   widget.controller.reverse();

                          //   _kids.of(context).setFalse();
                          // }
                          // else{
                          //   _kids.of(context).setTrue();
                          //   widget.controller.forward();

                          // }
                        },
                        child: Container(
                          height: 100,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFCE3F2),
                                    image: DecorationImage(
                                        image: img(), fit: BoxFit.cover)),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    name(),
                                    age()
                                    // Text(name == null ? 'No kids' : name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                                    // Text(age == null ? 'No data' : age,style: TextStyle(fontSize: 12),)
                                  ],
                                ),
                              ),
                              Container(
                                height: 16,
                                child: ClipRect(
                                    child: Stack(children: <Widget>[
                                  SlideTransition(
                                    position: animation,
                                    child: Image.asset(
                                      'assets/icons/hide.png',
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top:16),
                                    //   child: Image.asset('assets/icons/expand.png'),
                                    // ),
                                  ),
                                  SlideTransition(
                                    position: animation,
                                    child: Transform.translate(
                                      offset: Offset(0, 16),
                                      child: Image.asset(
                                          'assets/icons/expand.png'),
                                    ),
                                  )
                                ])),
                              )
                            ],
                          ),
                        ),
                      )
                    ])),
          ],
        );
      },
    );
  }
}

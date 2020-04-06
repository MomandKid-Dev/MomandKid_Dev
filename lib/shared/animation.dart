import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class makAnimation {
  makAnimation({this.controller}):
  slideAnimation = Tween<Offset>(begin: Offset(0,-1),end: Offset(0,0)).animate(CurvedAnimation(curve: Curves.easeInOutExpo,parent: controller)),
  slideAnimationBlur = Tween<Offset>(begin: Offset(0,-1),end: Offset(0,0)).animate(CurvedAnimation(curve: Curves.easeInOutExpo,parent: controller)),
  opaAnimationBlur = Tween<double>(begin: 0,end: 10).animate(controller);





  AnimationController controller;
  Animation<Offset> slideAnimation;
  Animation<Offset> slideAnimationBlur;
  Animation<double> opaAnimationBlur;
}

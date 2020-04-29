import 'package:flutter/material.dart';

allRoundedCorner(double val) => BorderRadius.all(Radius.circular(val));
topRoundedCorner(double val) => BorderRadius.only(topLeft: Radius.circular(val), topRight: Radius.circular(val));
botRoundedCorner(double val) => BorderRadius.only(bottomLeft: Radius.circular(val), bottomRight: Radius.circular(val));
gradientBackground() => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFF9AB3),Color(0xff9CCBFF)]
          );

edgeLR(double val) => EdgeInsets.only(left: val, right: val);
edgeTB(double val) => EdgeInsets.only(top: val, bottom: val);
edgeAll(double val) => EdgeInsets.all(val);
customEdge(double top,double bot, double left, double right) => EdgeInsets.only(top: top,bottom: bot, left: left, right: right);
shadow(double blurRadius) => [BoxShadow(color: Colors.grey,blurRadius: blurRadius,spreadRadius: 0.0,offset: Offset(0.0,0.0))];

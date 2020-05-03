
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:momandkid/shared/circleImg.dart';
class appBar extends SliverPersistentHeaderDelegate{
  final double maxHeight, minHeight;
  appBar({this.maxHeight,this.minHeight});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return LayoutBuilder(
      builder: (context, constraints){
        return Stack(
          children: <Widget>[
            Container(
              height: 150,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: 150,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'circleImg',
                          child:circleImg(img: AssetImage('assets/icons/037-baby.png'),height: 80,width: 80,)
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Peter Parker',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                              Text('Two Month old',style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        
                        GestureDetector(
                          child: Image.asset('assets/icons/expand.png',width: 16.65,),
                        )
                      ],
                    ),
                  ),

                  
                ]
              )
            ),
            
          ],
        );
      },
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

}
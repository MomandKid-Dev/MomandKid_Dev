import 'package:flutter/cupertino.dart';

class circleImg extends StatelessWidget{
  circleImg({this.img,this.height,this.width});
  dynamic img;
  double height,width;
  @override
  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: img,
          fit: BoxFit.cover
        )
      ),
    );
  }
}
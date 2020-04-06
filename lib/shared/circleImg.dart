import 'package:flutter/cupertino.dart';

class circleImg extends StatelessWidget{
  circleImg({this.img,this.height,this.width});
  String img;
  double height,width;
  @override
  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/icons/${img}'),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
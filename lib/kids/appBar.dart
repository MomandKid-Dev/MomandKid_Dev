import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class appBar extends StatefulWidget {
  appBar({this.title, this.img});
  String title, img;
  String _title, _img;

  @override
  _appBarState createState() => _appBarState();
}

class _appBarState extends State<appBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
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
                          '${widget.title}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Image(
                          image: AssetImage('${widget.img}'),
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
                      child: Image.asset(
                        'assets/icons/add.png',
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
//service
import 'package:momandkid/services/auth.dart';

class settingPage extends StatefulWidget {
  settingPage({this.auth, this.logoutCallback, this.userId});

  final AuthService auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 30, top:60, right: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE2F1), Color(0xFFE9F2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            )
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child:Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 30,color: Color(0xFF131048)), 
                  onPressed: (){
                    Navigator.pop(context);
                  } 
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFFBBBCD),
                    width: 8
                  )
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Color(0xFFFBBBCD),
                  size: 110,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF89EB9),
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.person_outline,
                        color: Color(0xFFFBBBCD),
                        size: 160,
                      ),
                    )
                  ],
                )
              ),
            ),
            Align(
              alignment: Alignment(0, 0.12),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: EdgeInsets.only(right: 25),
                decoration: BoxDecoration(
                  color: Color(0xFFF89EB9),
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.notifications_none,
                        color: Color(0xFFFBBBCD),
                        size: 100,
                      ),
                    )
                  ],
                )
              ),
            ),
            Align(
              alignment: Alignment(0, 0.65),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFFF5D8D),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: RawMaterialButton(
                  onPressed: signOut,
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.8),
              child: FlatButton(
                onPressed: (){}, 
                child: Text(
                  'DELETE YOUR ACCOUNT',
                  style: TextStyle(
                    color: Color(0xFFF89EB9),
                    fontSize: 18
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/post/commentdata.dart';
import 'package:momandkid/post/postPage.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/shared/circleImg.dart';

class mainPostMainScreen extends StatefulWidget {
  Widget child;
  mainPostMainScreen({this.child});
  @override
  _mainScreenState createState() => _mainScreenState();
  static _mainScreenState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedMain>()
              as _inheritedMain)
          .data;
}

class _mainScreenState extends State<mainPostMainScreen> {
  Post post = Post();
  User user = User();
  @override
  Widget build(BuildContext context) {
    return _inheritedMain(child: widget.child, data: this);
  }
}

class _inheritedMain extends InheritedWidget {
  _mainScreenState data;
  _inheritedMain({@required Widget child, @required this.data})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}

class mainN extends StatefulWidget {
  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<mainN> {
  @override
  Widget build(BuildContext context) {
    return mainPostMainScreen(
      child: _page(),
    );
  }
}

class _page extends StatefulWidget {
  @override
  _pageState createState() => _pageState();
}

class _pageState extends State<_page> {
  @override
  Widget build(BuildContext context) {
    Widget post(BuildContext context,Map data) {
      img() {
        if (data != null) {
          if ((data['profileImg'] == null) |
              (data['profileImg'] == '')) {
            return AssetImage('assets/icons/404.png');
          } else {
            return NetworkImage(data['profileImg']);
          }
        }
        return AssetImage('assets/icons/404.png');
      }

      name() {
        if (data != null) {
          if ((data['profileName'] == null) |
              (data['profileName'] == '')) {
            return Text('Null');
          } else {
            return Text(data['profileName']);
          }
        }
        return Text('Null');
      }

      words() {
        if (data != null) {
          if ((data['postWord'] == null) |
              (data['postWord'] == '')) {
            return Text('Null');
          } else {
            return Text(data['postWord']);
          }
        }
        return Text('Null');
      }

      likes() {
        if (data != null) {
          return data['like'];
        }
        return false;
      }

      return Container(
        margin: edgeLR(10),
        decoration: BoxDecoration(
          borderRadius: allRoundedCorner(15),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 1,spreadRadius: 0.1,color: Color(0xffe3e3e3).withOpacity(0.4),offset: Offset(0,2))]
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: edgeAll(10),
                  child: circleImg(
                    img: '037-baby.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Text('Name')
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>mainPostScreen(data: data)));
              },
              child:Column(
                children: <Widget>[
                  Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: allRoundedCorner(15),
                      color: Colors.grey,
                      image: DecorationImage(image: img())),
                  ),
                  Container(
                    padding: edgeAll(20),
                    alignment: Alignment.centerLeft,
                    child: words(),
                  ),
                  
                ],
              ),
            ),
            Container(
              margin: customEdge(0, 15, 20, 20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.favorite_border),
                        Text('edit here')
                      ],
                    )
                      
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.comment),
                        Text('edit here')
                      ],
                    )
                      
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                ),
              ),
              Text("Home"),
              Container(
                width: 100,
                child: Icon(
                  Icons.notifications_none,
                  size: 40,
                ),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 150,
          child: ListView(children: mainPostMainScreen.of(context).post.posts.map((data)=>post(context, data)).toList(),padding: edgeAll(0),physics: BouncingScrollPhysics(),),
        )
      ],
    );
  }
}

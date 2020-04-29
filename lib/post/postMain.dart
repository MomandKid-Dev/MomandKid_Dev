import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/post/postPage.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/shared/circleImg.dart';


class mainPostMainScreen extends StatefulWidget {
  Widget child;
  Map data;
  String userId;
  mainPostMainScreen({this.child,this.data,this.userId});

  @override
  _mainScreenState createState() => _mainScreenState();
  static _mainScreenState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedMain>()
              as _inheritedMain)
          .data;
}

class _mainScreenState extends State<mainPostMainScreen> {
  // Post post = Post();
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
  mainN({this.data,this.userId});
  Map data;
  String userId;
  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<mainN> {
  @override
  Widget build(BuildContext context) {
    return mainPostMainScreen(
      child: post(data: widget.data,userId: widget.userId,),
      data: widget.data,
      userId: widget.userId,
    );
  }
}

// class _page extends StatefulWidget {
//   @override
//   _pageState createState() => _pageState();
// }

// class _pageState extends State<_page> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//           height: 150,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Container(
//                 width: 100,
//                 child: Icon(
//                   Icons.person_outline,
//                   size: 40,
//                 ),
//               ),
//               Text("Home"),
//               Container(
//                 width: 100,
//                 child: Icon(
//                   Icons.notifications_none,
//                   size: 40,
//                 ),
//               )
//             ],
//           ),
//         ),
//         // Container(
//         //   height: MediaQuery.of(context).size.height - 150,
//         //   child: ListView(children: mainPostMainScreen.of(context).post.posts.map((data)=>post(context, data)).toList(),padding: edgeAll(0),physics: BouncingScrollPhysics(),),
//         // )
//       ],
//     );
//   }
// }


class post extends StatefulWidget {
  Map data;
  String userId;
  post({this.data,this.userId});
  @override
  _postState createState() => _postState();
}

class _postState extends State<post> {
  @override
  Widget build(BuildContext context) {
    widget.data = mainPostMainScreen.of(context).widget.data;
    img() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          if ((mainPostMainScreen.of(context).widget.data['image'] == null) |
              (mainPostMainScreen.of(context).widget.data['image'] == '') |
              (mainPostMainScreen.of(context).widget.data['image'] == 'image path')) {
            return AssetImage('assets/icons/404.png');
          } else {
            return NetworkImage(widget.data['image']);
          }
        }
        return AssetImage('assets/icons/404.png');
      }

      userimg() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          if ((mainPostMainScreen.of(context).widget.data['userprofile'] == null) |
              (mainPostMainScreen.of(context).widget.data['userprofile'] == '') |
              (mainPostMainScreen.of(context).widget.data['userprofile'] == 'image path')) {
            return '037-baby.png';
          } else {
            return NetworkImage(widget.data['image']);
          }
        }
        return '037-baby.png';
      }

      name() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          if ((mainPostMainScreen.of(context).widget.data['username'] == null) |
              (mainPostMainScreen.of(context).widget.data['username'] == '')) {
            return Text('Null');
          } else {
            return Text(mainPostMainScreen.of(context).widget.data['username']);
          }
        }
        return Text('Null');
      }

      words() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          if ((mainPostMainScreen.of(context).widget.data['content'] == null) |
              (mainPostMainScreen.of(context).widget.data['content'] == '')) {
            return Text('Null');
          } else {
            return Text(mainPostMainScreen.of(context).widget.data['content']);
          }
        }
        return Text('Null');
      }

      likes() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          return mainPostMainScreen.of(context).widget.data['likes'];
        }
        return [];
      }

      likecount() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          return mainPostMainScreen.of(context).widget.data['likecount'];
        }
        return 0;
      }

      comments() {
        if (mainPostMainScreen.of(context).widget.data != null){
          return mainPostMainScreen.of(context).widget.data['commentcount'];
        }
        return 0;
      }
      
      liked() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          return mainPostMainScreen.of(context).widget.data['liked'];
        }
        return false;
      }

      pid() {
        if (mainPostMainScreen.of(context).widget.data != null) {
          return mainPostMainScreen.of(context).widget.data['pid'];
        }
        return null;
      }
    return Container(
      margin: edgeLR(10),
        decoration: BoxDecoration(
          borderRadius: allRoundedCorner(15),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 1,spreadRadius: 0.1,color: Color(0xffe3e3e3).withOpacity(0.4),offset: Offset(0,2))],
          ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: edgeAll(10),
                  child: circleImg(
                    img: userimg(),
                    height: 20,
                    width: 20,
                  ),
                ),
                name()
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>mainPostScreen(data: widget.data,userId: widget.userId,)));
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
                        // Icon(Icons.favorite_border),
                        favButton(like: liked()),
                      ],
                    )
                      
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.comment),
                        SizedBox(width: 10),
                        Text(comments().toString())
                      ],
                    )
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class favButton extends StatefulWidget{
  favButton({this.like});
  bool like;
  @override
  _favButtonState createState() => _favButtonState();
}

class _favButtonState extends State<favButton>{

  @override
  Widget build(BuildContext context){
    bool _disabled = false;
    getLike(){
      return widget.like;
    }
    setLike(){
      widget.like = !widget.like;
      mainPostMainScreen.of(context).widget.data['liked'] = !mainPostMainScreen.of(context).widget.data['liked'];
    }
    return Container(
      child:Row(
        children:<Widget>[
          IconButton(
            icon: getLike() ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            color:Colors.pink,

            onPressed: () async {
              if (_disabled) return; 
              else {
                _disabled = true;
                if(getLike()){
                  await Database(userId: mainPostMainScreen.of(context).widget.userId).removeLike(mainPostMainScreen.of(context).widget.data['pid']).whenComplete((){
                    setState(() {
                      setLike();
                      mainPostMainScreen.of(context).widget.data['likecount'] -= 1;
                    });
                  });
                }
                else {
                  await Database(userId: mainPostMainScreen.of(context).widget.userId).createLike(mainPostMainScreen.of(context).widget.data['pid']).whenComplete((){
                    setState(() {
                      setLike();
                      mainPostMainScreen.of(context).widget.data['likecount'] += 1;
                    });
                  });
                }
                _disabled = false;
              }
            },
          ),
          Text((mainPostMainScreen.of(context).widget.data['likecount']).toString()),
        ]
      )
    );
  }
}

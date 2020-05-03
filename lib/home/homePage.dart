import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:momandkid/Profile/profilePage.dart';
import 'package:momandkid/model/post.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:momandkid/schedule/notificationPage.dart';
import 'package:momandkid/story/storyMain.dart';
import 'package:momandkid/kids/healthMain.dart';
import 'package:momandkid/Article/mainArticle.dart';
import 'package:momandkid/schedule/mainSchedulePage.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:quiver/iterables.dart';
import 'package:uuid/uuid.dart';
import 'package:momandkid/story/storyData.dart';


//service
import 'package:momandkid/services/auth.dart';
import '../post/postMain.dart';
import '../services/database.dart';
import '../shared/style.dart';
import 'package:momandkid/post/createPost.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.auth, this.logoutCallback, this.userId, this.data});

  final AuthService auth;
  final VoidCallback logoutCallback;
  final String userId;
  dataTest data;

  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex;
  PageController _pageController;
  bool _visible = true;
  bool _showappbar = true;
  String _title;
  storyData story = storyData();
  @override
  void initState() {
    widget.data.getKiddo(widget.userId);

    super.initState();
    _pageController = PageController();
    currentIndex = 0;
    _title = 'Home';
  }

  // Future testData() {
  //   _data.kiddo[0]['sel'] = 1;
  //   print('test data: ${_data.kiddo[0]}');
  // }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      switch (index) {
        case 0:
          _title = 'Home';
          _visible = true;
          _showappbar = true;
          break;
        case 1:
          _title = 'Article';
          _visible = false;
          _showappbar = true;
          break;
        case 2:
          _title = ' ';
          _visible = false;
          _showappbar = false;
          break;
        case 3:
          _title = ' ';
          _visible = false;
          _showappbar = false;
          break;
        case 4:
          _title = ' ';
          _visible = false;
          _showappbar = false;
          break;
        default:
      }
      _pageController.jumpToPage(currentIndex);
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  List<Map> _postFromFirebasePost(AsyncSnapshot posts, AsyncSnapshot users) {
    List<Post> postss = [];
    for (List<dynamic> pu in zip([posts.data.documents, users.data])) {
      bool like = false;
      if (pu[0].data['likes'] != null)
        like = pu[0].data['likes'].contains(widget.userId);
      postss.add(Post(
        pid: pu[0].documentID,
        content: pu[0].data['content'] ?? '',
        image: pu[0].data['image'] ?? '',
        time: pu[0].data['time'] ?? null,
        uid: pu[0].data['uid'] ?? '',
        likecount: pu[0].data['likecount'] ?? 0,
        commentcount: pu[0].data['commentcount'] ?? 0,
        username: pu[1].data['name'] ?? '',
        userprofile: pu[1].data['image'] ??
            'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg',
        likes: pu[0].data['likes'] ?? [],
        liked: like ?? false,
      ));
    }
    List<Map> postsss = postss.map((post) => post.getMap()).toList();
    //postss.sort((a, b) => a.pid.compareTo(b.pid));
    return postsss;
  }
  // List<Map> postsss = postss.map((post) => post.getMap()).toList();
  // //FirebaseStorage storage = FirebaseStorage.getInstance();
  // //postss.sort((a, b) => a.pid.compareTo(b.pid));
  // return postsss;

  Future uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/${Uuid().v1()}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    return await storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print('test : ${dataTest().kiddo}');
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFB),
      key: _scaffoldKey,
      appBar: _showappbar
          ? AppBar(
              title: Text(
                _title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                  fontSize: 30.0,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(LineAwesomeIcons.user),
                color: Color(0xFF9FA2A7),
                iconSize: 30.0,
                // onPressed: signOut
                onPressed: () {
                  print(widget.data.kiddo);
                  Navigator.push(
                      context,
                      PageRouteTransition(
                          animationType: AnimationType.slide_left,
                          builder: (context) => mainProfile(
                                userId: widget.userId,
                                auth: widget.auth,
                                logoutCallback: widget.logoutCallback,
                                data: widget.data,
                              )));
                },
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(LineAwesomeIcons.bell),
                    color: Color(0xFF9FA2A7),
                    iconSize: 30.0,
                    onPressed: () async {
                      print(widget.data.vaccine);
                      Navigator.push(
                          context,
                          PageRouteTransition(
                              animationType: AnimationType.slide_right,
                              builder: (context) => MyNotificationPage()));
                    })
              ],
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size(0.0, 0.0),
            ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
              switch (index) {
                case 0:
                  _title = 'Home';
                  _visible = true;
                  _showappbar = true;
                  break;
                case 1:
                  _title = 'Article';
                  _visible = false;
                  _showappbar = true;
                  break;
                case 2:
                  _title = 'Page 3';
                  _visible = false;
                  _showappbar = false;
                  break;
                case 3:
                  _title = 'Page 4';
                  _visible = false;
                  _showappbar = false;
                  break;
                case 4:
                  _title = ' ';
                  _visible = false;
                  _showappbar = false;

                  break;
                default:
              }
            });
          },
          children: <Widget>[
            Container(
              color: Colors.white,
              child: FutureBuilder(
                  future: Database().getPostData(10),
                  builder: (BuildContext context, AsyncSnapshot postSnapshot) {
                    if (postSnapshot.hasError)
                      return Text('Error: ${postSnapshot.error}');
                    switch (postSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return ListView(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 330.0,
                              width: 370.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[100],
                                        blurRadius: 3.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 5.0))
                                  ]),
                            ),
                          ],
                        );
                      default:
                        return FutureBuilder(
                            future: Database().getUserDataFromPost(
                                postSnapshot.data.documents),
                            builder: (BuildContext context,
                                AsyncSnapshot userSnapshot) {
                              if (userSnapshot.hasError)
                                return Text('Error: ${userSnapshot.error}');
                              switch (userSnapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return ListView(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        height: 330.0,
                                        width: 370.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[100],
                                                  blurRadius: 3.0,
                                                  spreadRadius: 0.0,
                                                  offset: Offset(0.0, 5.0))
                                            ]),
                                      ),
                                    ],
                                  );
                                default:
                                  return ListView(
                                    children: _postFromFirebasePost(
                                            postSnapshot, userSnapshot)
                                        .map((postinfo) => mainN(
                                            data: postinfo,
                                            userId: widget.userId))
                                        .toList(),
                                    padding: edgeAll(0),
                                    physics: BouncingScrollPhysics(),
                                  );
                              }
                            });
                    }
                  }),
            ),
            Container(child: mainArticle()),
            Container(child: storyMain(data: story,)),
            Container(
                child: mainKidScreen(userId: widget.userId, data: widget.data)),
            Container(child: mainSchedule(userId: widget.userId)),
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: _visible ? 1 : 0,
        child: FloatingActionButton(
            backgroundColor: Color(0xFF76C5BA),
            child: Icon(
              Icons.edit,
              size: 30.0,
            ),
            onPressed: () async {
              final postCreated = await Navigator.push(
                  context,
                  PageRouteTransition(
                      animationType: AnimationType.slide_up,
                      builder: (context) => createPost()));
              uploadFile(postCreated[0])
                  .then((imageURL) => Database(userId: widget.userId)
                      .createPost(postCreated[1], imageURL))
                  .whenComplete(() {
                setState(() {});
              });
            }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
            ],
            borderRadius: BorderRadius.circular(18.0)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                gap: 5,
                activeColor: Color(0xFFFF7571),
                iconSize: 22,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Color(0xFFFFD5D4),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.lightbulb_outline,
                    text: 'Article',
                  ),
                  GButton(
                    icon: Icons.face,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: Icons.assignment_ind,
                    text: 'Healthy',
                  ),
                  GButton(
                    icon: Icons.event_note,
                    text: 'Schedule',
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  setState(() {
                    currentIndex = index;
                    changePage(currentIndex);
                  });
                }),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';
import 'package:photo_view/photo_view.dart';
import 'commentdata.dart';

class mainPostScreen extends StatefulWidget {
  mainPostScreen({this.data, this.userId});
  Map data;
  String userId;
  @override
  _mainPostScreenState createState() => _mainPostScreenState();
}

class _mainPostScreenState extends State<mainPostScreen> {
  @override
  Widget build(BuildContext context) {
    return posts(child: postPage(), data: widget.data, userId: widget.userId);
  }
}

class posts extends StatefulWidget {
  Widget child;
  Map data;
  String userId;
  posts({this.child, this.data, this.userId});
  @override
  _postsState createState() => _postsState();
  static _postsState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<inheritedPost>()
              as inheritedPost)
          .data;
}

class _postsState extends State<posts> with TickerProviderStateMixin {
  AnimationController slideController;
  Animation<Offset> slideAnimation;
  TextEditingController commentController;
  ScrollController scrollController;
  FocusNode commentNode;
  User user = User();
  Commentdata commentdata = Commentdata();

  var postBoxHeight;
  var testUser;
  var testComment;
  var testPost;
  var currentUid;

  Future loadCurrentUser(String uid) async {
    await Database(userId: uid).getUserData().then((userdata) {
      Map<String, dynamic> temp = {
        'uid': uid,
        'userprofile': userdata.data['image'],
        'username': userdata.data['name'],
      };
      user.users.add(temp);
    });
  }

  Future loadComment(String pid) async {
    await Database().getCommentFromPost(pid).then((commentsId) async {
      if (commentsId.data == null) {
        commentdata.comments.clear();
        return;
      }
      await Database()
          .getCommentDataFromPost(commentsId.data.keys.toList())
          .then((comments) async {
        setComment(comments);
        await Database().getUsersFromComment(comments).then((users) {
          setUser(users);
        });
      });
    });
  }

  @override
  initState() {
    super.initState();
    slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    commentController = TextEditingController();
    commentNode = FocusNode();
    slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.5))
        .animate(
            CurvedAnimation(curve: Curves.easeInExpo, parent: slideController));
    scrollController = ScrollController();
    testPost = widget.data;
    testUser = user;
    testComment = commentdata;
    currentUid = widget.userId;
    loadComment(widget.data['pid']).whenComplete(() {
      loadCurrentUser(widget.userId).whenComplete(() {
        if (!mounted) return;
        setState(() {
          testComment = commentdata;
          testUser = user;
        });
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    commentNode.dispose();
  }

  forward() {
    setState(() {
      slideController.forward();
    });
  }

  reverse() {
    setState(() {
      slideController.reverse();
    });
  }

  Future addComment(
    String postID,
    String userID,
    String comment,
  ) async {
    await Database(userId: userID).createComment(postID, comment).then((cid) {
      if (cid != null) {
        setState(() {
          Map<String, dynamic> temp = {
            'pid': postID,
            'uid': userID,
            'content': comment,
            'time': Timestamp.now()
          };
          commentdata.comments.add(temp);
        });
      }
    });
  }

  setComment(List<DocumentSnapshot> comments) {
    commentdata.comments.clear();
    for (DocumentSnapshot comment in comments) {
      Map<String, dynamic> temp = {
        'pid': comment.data['pid'],
        'uid': comment.data['uid'],
        'content': comment.data['content'],
        'time': comment.data['time']
      };
      commentdata.comments.add(temp);
    }
  }

  setUser(List<DocumentSnapshot> users) {
    user.users.clear();
    for (DocumentSnapshot userr in users) {
      Map<String, dynamic> temp = {
        'uid': userr.documentID,
        'userprofile': userr.data['image'],
        'username': userr.data['name']
      };
      user.users.add(temp);
    }
  }

  decreaseLike() {
    setState(() {
      widget.data['likecount'] -= 1;
    });
  }

  increaseLike() {
    setState(() {
      widget.data['likecount'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return inheritedPost(
      child: widget.child,
      data: this,
    );
  }
}

class inheritedPost extends InheritedWidget {
  final _postsState data;

  const inheritedPost({@required Widget child, this.data})
      : super(child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class postPage extends StatefulWidget {
  @override
  _postPageState createState() => _postPageState();
}

class _postPageState extends State<postPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: edgeAll(0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height - 100,
              color: Colors.white,
              child: CustomScrollView(
                controller: posts.of(context).scrollController,
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: MySliverAppBar(
                        maxHeight: 500,
                        minHeight: 300,
                        postBox: postBox(data: posts.of(context).testPost)),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 80,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(posts
                        .of(context)
                        .commentdata
                        .getComment(posts.of(context).testPost['pid'])
                        .map((data) => commentBox(
                              data: data,
                            ))
                        .toList()),
                  )
                ],
              )),
          selfComment(userId: posts.of(context).currentUid)
        ]));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double maxHeight, minHeight;
  Widget postBox;
  MySliverAppBar(
      {@required this.maxHeight,
      @required this.minHeight,
      @required this.postBox});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var image = posts.of(context).testPost['image'];
    if (image == 'image path' || image == null)
      image =
          'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg';
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 170),
                child: GestureDetector(
                    onTap: () async {
                      posts.of(context).forward();
                      await Future.delayed(Duration(milliseconds: 100),
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pictureView(pic: image)));
                      });
                      await Future.delayed(Duration(milliseconds: 200),
                          () async {
                        posts.of(context).reverse();
                      });
                      posts.of(context).commentNode.unfocus();
                    },
                    child: Hero(
                      tag: 'pic',
                      child: Image.network(image, fit: BoxFit.cover),
                    ))),
            Positioned(
                top: maxHeight - 200 - shrinkOffset < -30
                    ? -30
                    : maxHeight - shrinkOffset - 200,
                left: 0,
                child: SlideTransition(
                  position: posts.of(context).slideAnimation,
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: dec(context),
                          child: postBox,
                        )),
                  ),
                )),
          ],
        );
      },
    );
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;
}

//Post Decoration
dec(BuildContext context) => BoxDecoration(
    color: Colors.white,
    borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(40.0),
        topRight: const Radius.circular(40.0)));

//CommentBox

class commentBox extends StatefulWidget {
  commentBox({this.data});
  Map data;
  @override
  _commentBoxState createState() => _commentBoxState();
}

class _commentBoxState extends State<commentBox> {
  bool favoritePressed = false;
  bool commentPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )),
        ),
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: edgeTB(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 50,
                  height: 50,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(posts
                              .of(context)
                              .testUser
                              .getProfilePic(widget.data['uid'])))),
                ),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 170,
                        minWidth: MediaQuery.of(context).size.width - 170),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          posts
                              .of(context)
                              .testUser
                              .getProfileName(widget.data['uid']),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                        Divider(),
                        Text(
                          widget.data['content'],
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ));
  }
}

class postBox extends StatefulWidget {
  Map data;
  postBox({this.data});
  @override
  _postBoxState createState() => _postBoxState();
}

var pheight;

class _postBoxState extends State<postBox> {
  final GlobalKey _postKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
  }

  getHeight() {
    RenderBox _pBox = _postKey.currentContext.findRenderObject();
    pheight = _pBox.size.height;
  }

  @override
  Widget build(BuildContext context) {
    img() {
      if (widget.data != null) {
        if ((widget.data['userprofile'] == null) |
            (widget.data['userprofile'] == '') |
            (widget.data['userprofile'] == 'image path')) {
          return AssetImage('assets/icons/404.png');
        } else {
          return NetworkImage(widget.data['userprofile']);
        }
      }
      return AssetImage('assets/icons/404.png');
    }

    name() {
      if (widget.data != null) {
        if ((widget.data['username'] == null) |
            (widget.data['username'] == '')) {
          return Text('Null');
        } else {
          return Text(widget.data['username']);
        }
      }
      return Text('Null');
    }

    words() {
      if (widget.data != null) {
        if ((widget.data['content'] == null) | (widget.data['content'] == '')) {
          return Text('Null');
        } else {
          return Text(widget.data['content']);
        }
      }
      return Text('Null');
    }

    liked() {
      if (widget.data != null) {
        return widget.data['liked'];
      }
      return false;
    }

    return Container(
      key: _postKey,
      constraints: BoxConstraints(maxHeight: 281, minHeight: 281),
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
            padding: EdgeInsets.only(bottom: 12),
            margin: EdgeInsets.only(bottom: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: 8,
                child: FlatButton(
                  onPressed: (){
                      Navigator.pop(context);
                    },
                  color: Colors.grey,
                  child: Container(),
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 20),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          new DecorationImage(fit: BoxFit.fill, image: img()),
                    ),
                  ),
                  name()
                ],
              )),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.topLeft,
            child: words(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                border: Border.all(color: Color(0x878787).withAlpha(80)),
                boxShadow: [
                  new BoxShadow(
                      spreadRadius: 1.0,
                      blurRadius: 1.0,
                      color: Color(0x878787).withAlpha(50))
                ]),
            child: SizedBox(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 6,
                              child: favButton(
                                like: liked(),
                              )),
                          Expanded(
                            flex: 4,
                            child: Text((widget.data['likecount']).toString()),
                          )
                        ],
                      ),
                    ),
                    Text('|'),
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: <Widget>[
                            Expanded(child: commentButton()),
                            Expanded(
                                child: Text(
                                    (widget.data['commentcount']).toString()))
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Comment',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}

class favButton extends StatefulWidget {
  favButton({this.like});
  bool like;
  @override
  _favButtonState createState() => _favButtonState();
}

class _favButtonState extends State<favButton> {
  @override
  Widget build(BuildContext context) {
    bool _disabled = false;
    getLike() {
      return widget.like;
    }

    setLike() {
      widget.like = !widget.like;
      posts.of(context).widget.data['liked'] =
          !posts.of(context).widget.data['liked'];
    }

    return Container(
        child: Row(children: <Widget>[
      IconButton(
        icon: getLike() ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: Colors.pink,
        onPressed: () async {
          if (_disabled)
            return;
          else {
            _disabled = true;
            if (getLike()) {
              await Database(userId: posts.of(context).widget.userId)
                  .removeLike(posts.of(context).widget.data['pid'])
                  .whenComplete(() {
                setState(() {
                  setLike();
                  posts.of(context).decreaseLike();
                });
              });
            } else {
              await Database(userId: posts.of(context).widget.userId)
                  .createLike(posts.of(context).widget.data['pid'])
                  .whenComplete(() {
                setState(() {
                  setLike();
                  posts.of(context).increaseLike();
                });
              });
            }
            _disabled = false;
          }
        },
      ),
    ]));
  }
}

class commentButton extends StatefulWidget {
  @override
  _commentButtonState createState() => _commentButtonState();
}

class _commentButtonState extends State<commentButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.comment),
      color: Colors.pink,
      onPressed: () {
        setState(() {
          posts.of(context);
        });
      },
    );
  }
}

class pictureView extends StatefulWidget {
  pictureView({this.pic});
  String pic;
  @override
  _pictureViewState createState() => _pictureViewState();
}

class _pictureViewState extends State<pictureView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        heroAttributes: PhotoViewHeroAttributes(tag: 'pic'),
        imageProvider: NetworkImage(widget.pic),
      ),
    );
  }
}

class selfComment extends StatefulWidget {
  String userId;
  selfComment({this.userId});
  @override
  _selfCommentState createState() => _selfCommentState();
}

class _selfCommentState extends State<selfComment> {
  @override
  dynamic _userimg = AssetImage('assets/icons/404.png');
  void initState() {
    super.initState();
    Database(userId: widget.userId).getUserData().then((user) {
      if ((user.data['image'] != null) |
          (user.data['image'] != 'image path') |
          (user.data['image'] != ''))
        setState(() {
          _userimg = NetworkImage(user.data['image']);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _disable = false;

    return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            circleImg(
              img: _userimg,
              height: 50,
              width: 50,
            ),
            Container(
              width: 200,
              height: 40,
              child: TextField(
                decoration: InputDecoration(),
                focusNode: posts.of(context).commentNode,
                controller: posts.of(context).commentController,
              ),
            ),
            GestureDetector(
                onTap: () async {
                  if (posts.of(context).commentController.text != '' &&
                      !_disable) {
                    _disable = true;
                    await posts
                        .of(context)
                        .addComment(
                            posts.of(context).testPost['pid'],
                            posts.of(context).currentUid,
                            posts.of(context).commentController.text)
                        .whenComplete(() {
                      posts.of(context).widget.data['commentcount'] += 1;
                      posts.of(context).commentController.text = '';
                      posts.of(context).scrollController.animateTo(
                          posts
                                  .of(context)
                                  .scrollController
                                  .position
                                  .maxScrollExtent +
                              100,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOutExpo);
                      _disable = false;
                    });
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.send),
                ))
          ],
        ));
  }
}

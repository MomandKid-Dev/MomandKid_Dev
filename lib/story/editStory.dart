import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momandkid/services/database.dart';

class editStoryScreen extends StatefulWidget {
  editStoryScreen({this.data, this.kidId, this.userId});
  Map data;
  String kidId;
  String userId;
  @override
  _editStoryScreenState createState() => _editStoryScreenState();
}

class _editStoryScreenState extends State<editStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return _story(
        child: editStory(),
        data: widget.data,
        kidId: widget.kidId,
        userId: widget.userId);
  }
}

class editStory extends StatefulWidget {
  Map data;
  String title = '';
  bool editing = false;
  var coverImg;
  @override
  _editStoryState createState() => _editStoryState();
}

class _story extends StatefulWidget {
  final Widget child;
  Map data;
  String kidId;
  String userId;
  _story(
      {@required this.child,
      @required this.data,
      @required this.kidId,
      @required this.userId});

  static _storyState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedStory>()
              as _inheritedStory)
          .data;
  @override
  _storyState createState() => _storyState();
}

class _storyState extends State<_story> {
  bool editing = false;
  bool remove = false;

  setTrue() {
    setState(() {
      this.editing = true;
    });
  }

  setFalse() {
    setState(() {
      this.editing = false;
    });
  }

  setRemoveTrue() {
    setState(() {
      this.remove = true;
    });
  }

  setRemoveFalse() {
    setState(() {
      this.remove = false;
    });
  }

  removePic(int index) async {
    if (widget.data['images'][index].runtimeType != String) {
      setState(() {
        widget.data['images'].removeAt(index);
      });
    } else {
      await Database()
          .removeImageFromStory(
              widget.data['sid'], widget.data['images'][index])
          .whenComplete(() {
        setState(() {
          widget.data['images'].removeAt(index);
        });
      });
    }
  }

  setStory(String story) {
    setState(() {
      widget.data['content'] = story;
    });
  }

  updateStory() {
    setState(() {
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // data = widget.data;
    return _inheritedStory(
      data: this,
      child: widget.child,
    );
  }
}

class _inheritedStory extends InheritedWidget {
  final _storyState data;
  const _inheritedStory({@required this.data, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}

class _editStoryState extends State<editStory> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController _slideController;
  Animation<Offset> _slideAnimation;
  @override
  void initState() {
    // TODO: implement
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -10), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.easeInOutExpo));
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    widget.data = _story.of(context).widget.data;
    widget.coverImg = widget.data['coverImg'];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            height: screenHeight,
            width: screenWidth,
            child: Stack(children: [
              _coverImage(data: _story.of(context).widget.data),
              Positioned(
                  top: 30,
                  left: 20,
                  child: SlideTransition(
                      position: _slideAnimation,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          List<dynamic> imagess = [];
                          List<dynamic> temp = [];
                          for (dynamic image
                              in _story.of(context).widget.data['images']) {
                            if (image.runtimeType != String)
                              imagess.add(image);
                            else
                              temp.add(image);
                          }
                          await Future.wait(imagess
                                  .map((image) => Database().uploadFile(image)))
                              .then((urls) async {
                            await Future.wait(urls.map((url) async {
                              temp.add(url);
                              await Database().addImageToStory(
                                  _story.of(context).widget.data['sid'], url);
                            }));
                          }).whenComplete(() {
                            _story.of(context).widget.data['images'] = temp;
                            Navigator.pop(context, false);
                          });
                        },
                        heroTag: "btn1",
                        child: Icon(
                          Icons.arrow_downward,
                          color: Color(0xff131048),
                        ),
                      ))),
              speedDial(
                left: screenWidth - 70,
                slideController: controller,
                data: widget.data,
              ),
            ])));
  }
}

class speedDial extends StatefulWidget {
  speedDial({this.left, this.slideController, this.data});

  double left;
  bool open = false;
  bool editing = false;
  Map data;
  AnimationController slideController;
  @override
  _speedDialState createState() => _speedDialState();
}

class _speedDialState extends State<speedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  AnimationController _slideController;
  AnimationController _slideController2;
  Animation<Offset> _slideAnimation;
  Animation<Offset> _slideAnimation2;
  double dialSize = 50;

  void _isOpen() {
    if (widget.open) {
      setState(() {
        _controller.reverse();
        _slideController2.reverse();
        widget.open = false;
      });
    } else if (!widget.open && !_story.of(context).editing) {
      setState(() {
        _controller.forward();
        _slideController2.forward();
        widget.open = true;
      });
    } else if (!widget.open && _story.of(context).editing) {
      setState(() {
        _story.of(context).setFalse();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _slideController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideController2 = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, -10), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.easeInOutExpo));
    _slideAnimation2 = Tween<Offset>(begin: Offset(0, -0.4), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _slideController2, curve: Curves.easeIn));
  }

  @override
  dispose() {
    super.dispose();
    _slideController.dispose();
    _controller.dispose();
    _slideController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _slideController.forward();
    return Positioned(
        top: 30,
        left: widget.left,
        child: SlideTransition(
            position: _slideAnimation,
            child: Row(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: dialSize,
                    width: dialSize,
                    margin: edgeAll(3),
                    child: FloatingActionButton(
                        heroTag: "btn2",
                        backgroundColor: Colors.white,
                        onPressed: () {
                          _isOpen();
                        },
                        child: AnimatedIcon(
                            progress: _animation,
                            icon: AnimatedIcons.menu_close,
                            color: Color(0xff131048))),
                  ),
                  Container(
                      height: dialSize,
                      width: dialSize,
                      margin: edgeAll(3),
                      child: SlideTransition(
                        position: _slideAnimation2,
                        child: FadeTransition(
                          opacity: _animation,
                          child: FloatingActionButton(
                            heroTag: "btn3",
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Color(0xff131048),
                            ),
                            onPressed: () async {
                              _isOpen();

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => editor2(
                                            data: widget.data,
                                            slideController: _controller,
                                          )));
                            },
                          ),
                        ),
                      )),
                  Container(
                      height: dialSize,
                      width: dialSize,
                      margin: edgeAll(3),
                      child: SlideTransition(
                        position: _slideAnimation2,
                        child: FadeTransition(
                          opacity: _animation,
                          child: FloatingActionButton(
                            heroTag: "btn5",
                            backgroundColor: Colors.white,
                            child: Icon(Icons.delete, color: Color(0xff131048)),
                            onPressed: () async {
                              await Database(
                                      userId: _story.of(context).widget.userId)
                                  .removeStory(widget.data['sid'],
                                      _story.of(context).widget.kidId)
                                  .whenComplete(
                                      () => Navigator.pop(context, true));
                            },
                          ),
                        ),
                      ))
                ],
              ),
            ])));
  }
}

class _coverImage extends StatefulWidget {
  _coverImage({this.data});
  String title;
  Map data;
  bool editing;
  var coverImg;
  bool remove = false;
  @override
  _coverImageState createState() => _coverImageState();
}

class _coverImageState extends State<_coverImage> {
  TextEditingController textController;
  @override
  void initState() {
    super.initState();
  }

  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;

    setState(() {
      if (_image != null) widget.data['images'].add(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    textController = TextEditingController(
      text: widget.data['content'] == ''
          ? 'edit to add some text'
          : widget.data['content'],
    );
    return ListView(
        physics: BouncingScrollPhysics(),
        padding: edgeAll(0),
        children: <Widget>[
          Container(
              height: 380,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: <Widget>[
                Positioned(
                    top: -80,
                    left: -100,
                    child: Hero(
                        tag: 'pic${widget.data['id']}',
                        child: Container(
                          height: 450,
                          width: 450,
                          decoration: widget.data['coverImg'] == null
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffF2C7C7))
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: widget.data['coverImg']
                                                  .runtimeType ==
                                              String
                                          ? NetworkImage(
                                              widget.data['coverImg'])
                                          : FileImage(widget.data['coverImg']),
                                      fit: BoxFit.cover),
                                ),
                        )))
              ])),
          Container(
              padding: edgeLR(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: edgeTB(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            widget.data['title'] == ''
                                ? 'Daily Note'
                                : widget.data['title'],
                            style: TextStyle(
                                fontSize: 27,
                                color: Color(0xff131048),
                                fontWeight: FontWeight.bold)),
                        Text(toDate(widget.data['date']),
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff131048).withAlpha(400),
                                fontWeight: FontWeight.bold)),
                        // Text(widget.data['date'].toString(),style: TextStyle(fontSize: 20,color: Color(0xff131048).withAlpha(400),fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    margin: edgeTB(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Your Daily Note',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color(0xff131048),
                                fontWeight: FontWeight.normal)),
                        widget.data['content'] == ''
                            ? Text('edit to add some text',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff131048).withAlpha(400),
                                    fontWeight: FontWeight.normal))
                            : Text(widget.data['content'],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff131048).withAlpha(400),
                                    fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        // controller: PageController(viewportFraction: 1/2),
                        itemCount: widget.data['images'].length + 1,
                        itemBuilder: (_, i) {
                          if (i == widget.data['images'].length) {
                            return GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  // height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: allRoundedCorner(20),
                                    color: Colors.grey[300],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  width: MediaQuery.of(context).size.width / 3,
                                ));
                          }

                          return images(
                            image: widget.data['images'][i],
                            index: i,
                            data: widget.data,
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ))
        ]);
  }
}

class images extends StatefulWidget {
  images({this.image, this.index, this.data});
  dynamic image;
  int index;
  Map data;
  @override
  _imagesState createState() => _imagesState();
}

class _imagesState extends State<images> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<double> animation2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0.85, end: 1).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: controller));
    animation2 = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: controller));
  }

  @override
  Widget build(BuildContext context) {
    int remove = 0;
    if (_story.of(context).remove) {
      controller.reverse();
    } else if (!_story.of(context).remove) {
      controller.forward();
    }
    return Hero(
        tag: 'img${widget.index}',
        child: GestureDetector(
            onTap: () {
              if (!_story.of(context).remove) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => picture(
                              image: widget.image,
                              index: widget.index,
                            )));
              } else {
                _story.of(context).setRemoveFalse();
              }
            },
            onLongPress: () {
              if (!_story.of(context).remove) {
                _story.of(context).setRemoveTrue();
              } else {
                _story.of(context).setRemoveFalse();
              }
            },
            child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  ScaleTransition(
                      scale: animation,
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.height / 5,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: allRoundedCorner(20),
                            boxShadow: _story.of(context).remove
                                ? [
                                    BoxShadow(
                                        blurRadius: 7,
                                        spreadRadius: 3,
                                        color: Color(0xff999999))
                                  ]
                                : null,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (widget.image.runtimeType == String)
                                  ? ((widget.image == null) |
                                          (widget.image == 'image path'))
                                      ? AssetImage('assets/icons/cover.jpg')
                                      : NetworkImage(widget.image)
                                  : FileImage(widget.image),
                            )),
                      )),
                  ScaleTransition(
                    scale: animation2,
                    child: GestureDetector(
                      onTap: () {
                        _story.of(context).removePic(widget.index);
                        if (_story.of(context).widget.data['images'].length ==
                            0) {
                          _story.of(context).setRemoveFalse();
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ])));
  }
}

class editor2 extends StatefulWidget {
  editor2({this.data, this.slideController});
  AnimationController slideController;
  Map data;
  @override
  _editor2State createState() => _editor2State();
}

class _editor2State extends State<editor2> with TickerProviderStateMixin {
  TextEditingController textController;
  TextEditingController titleTextController;
  AnimationController controller;
  Animation<Offset> animation;
  bool pressable = false;
  bool storyChanged = false,
      titleChanged = false,
      dayChanged = false,
      coverImgChanged = false;
  var _oldStory, _oldTitle, _oldDay;
  var _oldCoverImg;
  var tempDay, tempStory, tempTitle;
  var tempCoverImg;
  calendarBox(BuildContext context) {
    return showDatePicker(
            context: context,
            initialDate: tempDay,
            firstDate: DateTime(1980),
            lastDate: DateTime(2222))
        .then((newDate) {
      setState(() {
        if (newDate != _oldDay) {
          setState(() {
            dayChanged = true;
          });
        } else {
          setState(() {
            dayChanged = false;
          });
        }
        setState(() {
          tempDay = newDate;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0)).animate(
        CurvedAnimation(curve: Curves.easeInOutExpo, parent: controller));
    controller.forward();
    _oldDay = widget.data['date'];
    _oldCoverImg = widget.data['coverImg'];
    _oldStory = widget.data['content'];
    _oldTitle = widget.data['title'];
    tempCoverImg = widget.data['coverImg'];
    tempDay = widget.data['date'];
    tempTitle = widget.data['title'];
    tempStory = widget.data['content'];
    textController = TextEditingController(
      text: tempStory,
    );
    titleTextController = TextEditingController(text: tempTitle);
  }

  File _image;
  Future getImage() async {
    setState(() {
      tempTitle = titleTextController.text;
      tempStory = textController.text;
    });

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;

    if (_image != null) {
      setState(() {
        tempCoverImg = (_image);
      });
    }

    if (_oldCoverImg != tempCoverImg) {
      setState(() {
        coverImgChanged = true;
      });
    } else {
      setState(() {
        coverImgChanged = false;
      });
    }
    setState(() {
      titleTextController.text = tempTitle;
      textController.text = tempStory;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(tempTitle);
    pressable = (dayChanged | storyChanged | titleChanged | coverImgChanged);
    return Scaffold(
        body: ListView(
            physics: ClampingScrollPhysics(),
            padding: edgeAll(0),
            children: <Widget>[
          Column(children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height - 100,
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: edgeAll(0),
                    children: <Widget>[
                      Container(
                          height: 310,
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Positioned(
                                  child: Hero(
                                    tag: 'pic${widget.data['id']}',
                                    child: Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: tempCoverImg == null
                                          ? BoxDecoration(
                                              borderRadius:
                                                  topRoundedCorner(20),
                                              color: Color(0xffF2C7C7))
                                          : BoxDecoration(
                                              borderRadius:
                                                  topRoundedCorner(20),
                                              image: DecorationImage(
                                                  image: tempCoverImg
                                                              .runtimeType ==
                                                          String
                                                      ? NetworkImage(
                                                          tempCoverImg)
                                                      : FileImage(tempCoverImg),
                                                  fit: BoxFit.cover),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  left: MediaQuery.of(context).size.width - 60,
                                  child: FloatingActionButton(
                                    heroTag: 'btn99',
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Color(0xff131480),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 240,
                                    child: SlideTransition(
                                        position: animation,
                                        child: GestureDetector(
                                          onTap: () {
                                            getImage();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 200,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    allRoundedCorner(40),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                      color: Color(0xff999999),
                                                      offset: Offset(0, 1))
                                                ]),
                                            child: Text('UPLOAD NEW COVER'),
                                          ),
                                        )))
                              ])),
                      Container(
                          padding: edgeLR(20),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: edgeTB(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextField(
                                      controller: titleTextController,
                                      enabled: true,
                                      maxLines: 20,
                                      minLines: 1,
                                      onChanged: (text) {
                                        if (_oldTitle == text) {
                                          setState(() {
                                            titleChanged = false;
                                          });
                                        } else {
                                          setState(() {
                                            titleChanged = true;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: 27,
                                          color: Color(0xff131048),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'EDIT TITLE',
                                          hintStyle: TextStyle(
                                              color: Color(0xff131048))),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        calendarBox(context);
                                      },
                                      child: Text(toDate(tempDay),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff131048)
                                                  .withAlpha(400),
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: edgeTB(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Your Daily Note',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Color(0xff131048),
                                            fontWeight: FontWeight.normal)),
                                    TextField(
                                      controller: textController,
                                      enabled: true,
                                      maxLines: 20,
                                      minLines: 1,
                                      onChanged: (text) {
                                        if (_oldStory == text) {
                                          setState(() {
                                            storyChanged = false;
                                          });
                                        } else {
                                          setState(() {
                                            storyChanged = true;
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color(0xff131048).withAlpha(400),
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ))
                    ])),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: GestureDetector(
                  onTap: () async {
                    if (pressable) {
                      if (!coverImgChanged) {
                        await Database()
                            .updateStoryData(widget.data['sid'], tempCoverImg,
                                titleTextController.text, textController.text)
                            .whenComplete(() {
                          setState(() {
                            widget.data['content'] = textController.text;
                            _oldStory = widget.data['content'];
                            widget.data['coverImg'] = tempCoverImg;
                            widget.data['date'] = tempDay;
                            widget.data['title'] = titleTextController.text;
                            _oldDay = widget.data['date'];
                            _oldTitle = widget.data['title'];
                            pressable = false;
                            dayChanged = false;
                            storyChanged = false;
                            titleChanged = false;
                            coverImgChanged = false;
                          });
                        });
                      } else {
                        await Database()
                            .uploadFile(tempCoverImg)
                            .then((url) async {
                          await Database()
                              .updateStoryData(widget.data['sid'], url,
                                  titleTextController.text, textController.text)
                              .whenComplete(() {
                            setState(() {
                              widget.data['content'] = textController.text;
                              _oldStory = widget.data['content'];
                              widget.data['coverImg'] = url;
                              widget.data['date'] = tempDay;
                              widget.data['title'] = titleTextController.text;
                              _oldDay = widget.data['date'];
                              _oldTitle = widget.data['title'];
                              pressable = false;
                              dayChanged = false;
                              storyChanged = false;
                              titleChanged = false;
                              coverImgChanged = false;
                            });
                          });
                        });
                      }
                    }
                  },
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: allRoundedCorner(40),
                            color: pressable
                                ? Color(0xff0263FB)
                                : Color(0xffA7C6F7),
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ])),
            )
          ])
        ]));
  }
}

class picture extends StatelessWidget {
  picture({this.image, this.index});
  int index;
  dynamic image;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'img${index}',
      child: Scaffold(
          body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: (image.runtimeType == File)
            ? Image.file(image)
            : ((image == null) | (image == 'image path'))
                ? Image.asset('assets/icons/cover.jpg')
                : Image.network(image),
      )),
    );
  }
}

toDate(DateTime date) {
  String newDate = '';
  List month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  newDate += date.day.toString();
  newDate += ' ';
  newDate += month[date.month - 1];
  newDate += ' ';
  newDate += date.year.toString();
  return newDate;
}

toDateTime(String date) {
  DateTime newDate = DateTime(int.parse(date.substring(4, 8)),
      int.parse(date.substring(2, 4)), int.parse(date.substring(0, 2)));
  return newDate;
}

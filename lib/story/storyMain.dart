import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momandkid/kids/healthMain.dart';
import 'package:momandkid/shared/appbar.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/story/addStoryPage.dart';
import 'package:momandkid/story/editStory.dart';
import 'package:momandkid/story/storyData.dart';

class storyMain extends StatefulWidget {
  storyMain({Key key, this.userId}) : super(key: key);
  StoryData data = StoryData();
  String userId;
  // PageController Stoontroller;
  int index = 0;

  @override
  _story createState() => _story();
}

class _story extends State<storyMain>
    with TickerProviderStateMixin{
  PageController storyController;
  
  Animation<Offset> slideAnimationBlur2;
  AnimationController slideController2;
  Animation<double> opaAnimationBlur2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storyController =
        PageController(initialPage: widget.index, viewportFraction: 1 / 1.25);
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideAnimationBlur2 = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController2));
    opaAnimationBlur2 =
        Tween<double>(begin: 10, end: 0).animate(slideController2);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.light // status bar color
    // ));
  }

  @override
  Widget build(BuildContext context) {
    if (true)
      slideController2.forward();
    return Stack(
    children:<Widget>[
    Container(
        color: Colors.white,
        child: Column(
          // physics: BouncingScrollPhysics() ,
          children: <Widget>[
            Container(
              child: appBar(
                kid: null,
              ),
              // pinned: false,
            ),
            Container(
                child: Container(
              height: MediaQuery.of(context).size.height - 186,
              child: Stack(
                // alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  // storyPreviewCard(),
                  Positioned(
                      left: MediaQuery.of(context).size.width - 80,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addStoryPage(
                                        data: widget.data,
                                      )));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xffd1d1d1).withOpacity(0.6),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20))),
                        ),
                      )),
                  Container(
                    // color: Colors.red,
                    // height: MediaQuery.of(context).size.height - 250,
                    // width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(
                      maxHeight: 500,
                    ),
                    margin: EdgeInsets.only(top: 50),
                    // color: Colors.red,
                    child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      // controller: storyController,
                      controller: storyController,
                      itemCount: widget.data.getAllStory().length + 1,
                      onPageChanged: (int i) {
                        setState(() {
                          widget.index = i;
                        });

                        // print(index);
                      },

                      itemBuilder: (_, i) {
                        if (widget.index == null) {
                          widget.index = 0;
                        }
                        if (i == widget.data.getAllStory().length) {
                          return addStoryCard(
                            data: widget.data,
                            active: i == widget.index,
                            index: i,
                            controller: storyController,
                          );
                        }

                        return storyPreviewCard(
                          index: i,
                          active: i == widget.index,
                          data: widget.data.getStory(i),
                          controller: storyController,
                          datas: widget.data,
                        );
                      },
                    ),
                  )
                ],
              ),
            )
                // ]),
                )
          ],
        )
        ),
         SlideTransition(
        position: slideAnimationBlur2,
        child: blurTransition(
          animation: opaAnimationBlur2,
          controller: slideController2,
        ),
      ),
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class addStoryCard extends StatefulWidget {
  addStoryCard({this.data, this.active, this.index, this.controller});
  StoryData data;
  bool active;
  PageController controller;
  int index;
  @override
  _addStoryState createState() => _addStoryState();
}

class _addStoryState extends State<addStoryCard> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    animation = Tween<double>(begin: 1, end: 1).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.active) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return Hero(
        tag: 'addStory',
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ScaleTransition(
                scale: animation,
                child: GestureDetector(
                    onTap: () {
                      if (!widget.active) {
                        widget.controller.animateToPage(widget.index,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>editStory(data:widget.data)));
                      else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addStoryPage(
                                      data: widget.data,
                                    )));
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width + 300,
                      margin: edgeAll(10),
                      decoration: BoxDecoration(
                        borderRadius: allRoundedCorner(40),
                        gradient: gradientBackground(),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/icons/ic_create.png'),
                            SizedBox(
                              height: 20,
                            ),
                            Text('  TODAY STORY',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white))
                          ]),
                    )))));
  }
}

// addStoryCard(BuildContext context){

// }

addStorySideBar(BuildContext context) {
  return Container();
}

class storyPreviewCard extends StatefulWidget {
  storyPreviewCard(
      {this.index,
      this.active,
      this.data,
      this.controller,
      this.datas,
      this.newest});
  int index, current;
  bool active, newest;
  StoryData datas;
  Map data;
  bool exit;
  PageController controller;
  @override
  _storyPreviewState createState() => _storyPreviewState();
}

class _storyPreviewState extends State<storyPreviewCard>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController delController;
  Animation<double> animation;
  Animation<Offset> delAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    delController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animation = Tween<double>(begin: 1, end: 1).animate(controller);
    delAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1))
        .animate(delController);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.active) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return Container(
        child: SlideTransition(
            position: delAnimation,
            child: GestureDetector(
                onTap: () async {
                  // setState(() async {
                  //   // widget.current = widget.index;
                  //   // widget.controller.jumpToPage(widget.current);
                  //   // if(!widget.active){
                  //   //   widget.controller.animateToPage(widget.index, duration: Duration(milliseconds: 100), curve: Curves.easeIn);

                  //   // }
                  //   // widget.exit = await Navigator.push(context, MaterialPageRoute(builder: (context)=>editStory(data:widget.data)));
                  //   // print(widget.exit);
                  // });
                  if (!widget.active) {
                    widget.controller.animateToPage(widget.index,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                  } else {
                    var remove = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                editStoryScreen(data: widget.data)));

                    if (remove == null) {
                      null;
                    } else if (remove) {
                      widget.datas.getAllStory().removeAt(widget.index);
                    }
                  }
                },
                child: ScaleTransition(
                    scale: animation,
                    child: Stack(children: <Widget>[
                      Hero(
                        tag: 'pic${widget.data['id']}',
                        child: Container(
                          margin: edgeAll(10),
                          decoration: widget.data['coverImg'] == null
                              ? BoxDecoration(
                                  borderRadius: allRoundedCorner(40),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(0, 3))
                                  ],
                                  color: Color(0xffF2C7C7))
                              : BoxDecoration(
                                  color: Color(0xffF2C7C7),
                                  borderRadius: allRoundedCorner(40),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(0, 3))
                                  ],
                                  image: DecorationImage(
                                    image: widget
                                                .data['coverImg'].runtimeType ==
                                            String
                                        ? AssetImage(widget.data['coverImg'])
                                        : FileImage(widget.data['coverImg']),
                                    fit: BoxFit.cover,
                                  )),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: 50,
                        child: Text(
                          toDate(widget.data['date']).replaceAll(' ', '\n'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              shadows: [
                                Shadow(
                                  blurRadius: 20,
                                )
                              ]),
                        ),
                      ),
                      Positioned(
                          left: 25,
                          top: 250,
                          child: Text(
                            widget.data['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20,
                                  )
                                ]),
                          ))
                    ])))));
  }
}

toDate(String date) {
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
  if (int.parse(date.substring(0, 2)) < 10) {
    newDate += date.substring(1, 2);
  } else {
    newDate += date.substring(0, 2);
  }

  newDate += ' ';
  newDate += month[int.parse(date.substring(2, 4)) - 1];
  newDate += ' ';
  newDate += date.substring(4, 8);
  return newDate;
}

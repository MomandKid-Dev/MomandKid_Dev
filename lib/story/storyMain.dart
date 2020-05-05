import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'package:momandkid/kids/addkid.dart';
import 'package:momandkid/kids/healthMain.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/shared/appbar.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/story/addStoryPage.dart';
import 'package:momandkid/story/editStory.dart';
import 'package:momandkid/story/storyData.dart';

class mainStoryPage extends StatefulWidget {
  @override
  _mainStoryPageState createState() => _mainStoryPageState();
  String userId;
  dataTest kiddata;
  mainStoryPage({Key key, this.userId, this.kiddata}) : super(key: key);
}

class _mainStoryPageState extends State<mainStoryPage> {
  @override
  Widget build(BuildContext context) {
    
    return storyPage(child: storyMain(userId:widget.userId,kiddata:widget.kiddata),data: widget.kiddata,);
  }
}


class storyPage extends StatefulWidget {
  Widget child;
  dataTest data;
  
  
  storyPage({this.child,this.data});
   static _storyPageState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_inheritedStory>()
              as _inheritedStory)
          .data;
  @override
  _storyPageState createState() => _storyPageState();
}

class _storyPageState extends State<storyPage> with TickerProviderStateMixin{
  dataTest data;
  bool update = false;
   bool open = false;
   int index = 0;
    AnimationController slideController;
    Animation<Offset> slideAnimation;
    
  Animation<Offset> slideAnimationBlur2;
  Animation<double> opaAnimationBlur2;
  AnimationController slideController2;
  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
     slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    slideAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
    .animate(CurvedAnimation(
        curve: Curves.easeInOutExpo, parent: slideController));
    slideController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
         slideAnimationBlur2 = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
        .animate(CurvedAnimation(
            curve: Curves.easeInOutExpo, parent: slideController2));
    opaAnimationBlur2 =
        Tween<double>(begin: 10, end: 0).animate(slideController2);
  }
  @override 
  void dispose() {
    // TODO: implement dispose
    slideController.dispose();
    slideController2.dispose();
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return _inheritedStory(this,widget.child);
    
  }
  setSS(){
    setState(() {
    });
  }

  setIndex(int index){
    setState((){
      this.index = index;
    });
  }

  setTrue() {
    setState(() {
      this.open = true;
    });
  }

  setFalse() {
    setState(() {
      this.open = false;
    });
  }
  setSelectedKid(int id) {
    setState(() {
      data.setSelectedKid(id);
    });
    // data.getDataLogAll().whenComplete(() => loaded());
  }

  getSelectedKid() {
    setState(() {
      data.getSelectedKid();
    });
  }
  forward(){
    setState(() {
      slideController.forward();
    });
  }
  reverse(){
    setState(() {
      slideController.reverse();
    });
  }
}

class _inheritedStory extends InheritedWidget{
  final _storyPageState data;
  _inheritedStory(this.data, @required Widget child):super(child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  
}



class storyMain extends StatefulWidget {
  storyMain({Key key, this.userId, this.kiddata,}) : super(key: key);
  String userId;
  
  dataTest kiddata;
  // PageController Stoontroller;
  int index = 0;

  @override
  _story createState() => _story();
}



class _story extends State<storyMain>
    with TickerProviderStateMixin{
  PageController storyController;
  StoryData storyData;
  Map kids;
 
  
  int kidsCount;
  Future loadStory() async {
    
    //print('test ${widget.kiddata.kiddo[0]['kid']}');
    await Database().getStoryFromKid(widget.kiddata.getSelectedKid()['kid']).then((storyId) async {
      if (storyId.data == null) return;
      await Database().getStoriesData(storyId.data.keys.toList()).then((stories) {
        int i = 0;
         for (DocumentSnapshot story in stories){
           storyData.addStory(i++,story.documentID, story.data['title'], story.data['coverImg'], story.data['images'].toList(), story.data['content'], story.data['date'].toDate());
         }
      });
    });
    // await Database(userId: widget.userId).getBabyId().then((babyIds) async {
    //   await Future.wait(<Future>[
    //     Database().getStoryFromKid(babyIds[0]),
    //     Database().getBaby(babyIds)
    //   ]).then((datas) async {
    //     print(datas[1][0]);
    //     await Database().getStoriesData(datas[0].data.keys.toList()).then((stories) async {
    //       int i = 0;
    //      for (DocumentSnapshot story in stories){
    //        storyData.addStory(i, story.data['title'], story.data['coverImg'], story.data['images'], story.data['content'], story.data['date'].toDate());
    //      }
    //     });
    //   });
    // });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storyData = StoryData();
   
    
    storyController =
        PageController(initialPage: widget.index, viewportFraction: 1 / 1.25);
   
   
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.light // status bar color
    // ));
    
    loadStory().whenComplete((){
      if (!mounted) return;
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('WAHHHHJHHH ${widget.userId}');
    if(storyPage.of(context).update){
      
      // storyPage.of(context).update = true;
      storyPage.of(context).slideController2.reverse();
      storyData = StoryData();
      // storyPage.of(context).slideController2.forward();
        
        loadStory().whenComplete((){
        setState(() {
          // storyPage.of(context).slideController2.reverse();
          // storyPage.of(context).update = false;
        });
        storyPage.of(context).update = false;
        storyPage.of(context).slideController2.forward();
        }
      );
    }
    kidsCount = widget.kiddata.kiddo.length;
    if (storyPage.of(context).update == false)
      storyPage.of(context).slideController2.forward();
    return Stack(
    children:<Widget>[
    Container(
        color: Colors.white,
        child: Column(
          // physics: BouncingScrollPhysics() ,
          children: <Widget>[
            
            Container(
              child: appBar(
                data: widget.kiddata,
                kid: widget.kiddata.getSelectedKid(),
                open: storyPage.of(context).open,
                onTap: () {
                  if (storyPage.of(context).open) {
                    storyPage.of(context).slideController.reverse();
                    storyPage.of(context).setFalse();
                  } else {
                    storyPage.of(context).slideController.forward();
                    storyPage.of(context).setTrue();
                  }
                },
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
                          print('YYYYAAAAAAH ${widget.userId}');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addStoryPage(
                                        userId: widget.userId,
                                        data: storyData,
                                        kidId: widget.kiddata.getSelectedKid()['kid']
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
                      itemCount: storyData.getAllStory().length + 1,
                      onPageChanged: (int i) {
                        storyPage.of(context).setIndex(i);

                        // print(index);
                      },

                      itemBuilder: (_, i) {
                        if (storyPage.of(context).index == null) {
                          storyPage.of(context).index = 0;
                        }
                        if (i == storyData.getAllStory().length) {
                          return addStoryCard(
                            data: storyData,
                            active: i == storyPage.of(context).index,
                            index: i,
                            controller: storyController,
                            kidId: widget.kiddata.getSelectedKid()['kid'],
                            userId: widget.userId
                          );
                        }

                        return storyPreviewCard(
                          index: i,
                          active: i == storyPage.of(context).index,
                          data: storyData.getStory(i),
                          controller: storyController,
                          datas: storyData,
                          kidId: widget.kiddata.getSelectedKid()['kid'],
                          userId: widget.userId
                        );
                      },
                    ),
                  ),
                  SlideTransition(
          position: storyPage.of(context).slideAnimation,
          child: Container(
              height: (kidsCount) * 90.0,
              constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height -
                          150),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ListView.builder(
                padding: edgeAll(0),
                //childrenList\
                physics: BouncingScrollPhysics(),
                itemCount: kidsCount,
                itemBuilder: (_, i) {
                  // if (i == kidsCount) {
                  //   return GestureDetector(
                  //       onTap: () async {
                  //         //Add dek here
                  //         int temp = kidsCount;
                  //         await Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     mainAddScreen(
                  //                       userId: widget.userId,
                  //                       data: widget.kiddata,
                  //                     ))).whenComplete(() {
                  //           // kidsCount =
                  //           //     widget.data.kiddo.length;
                  //           // _kids
                  //           //     .of(context)
                  //           //     .setSelectedKid(kidsCount);
                  //         });
                  //       },
                  //       child: Container(
                  //         height: 83,
                  //         width: 200,
                  //         margin: edgeLR(20),
                  //         decoration: BoxDecoration(
                  //           borderRadius:
                  //               allRoundedCorner(15),
                  //           border: Border.all(
                  //               width: 2,
                  //               color: Color(0xff131048)
                  //                   .withOpacity(0.2)),
                  //           // color: Colors.red
                  //         ),
                  //         alignment: Alignment.center,
                  //         child: Text('Add Kid',
                  //             style: TextStyle(
                  //                 color: Color(0xff131048),
                  //                 fontSize: 18)),
                  //       ));
                  // }

                  return childrenList(
                    index: i,
                    img: widget.kiddata.getKids()[i]['image'],
                    name: widget.kiddata.getKids()[i]['name'],
                    controller: storyPage.of(context).slideController,
                    data: widget.kiddata,
                    userId: widget.userId,
                    // key: ValueKey('childrenListKEy'),
                  );
                },
                // children:<Widget>[childrenList(img: 'assets/icons/037-baby.png',name: 'nackkie',controller: slideController,)]
              )),
        ),
                ],
              ),
            )
                // ]),
                )
          ],
        )
        ),

        
        
        SlideTransition(
        position: storyPage.of(context).slideAnimationBlur2,
        child: blurTransition(
          animation: storyPage.of(context).opaAnimationBlur2,
          controller: storyPage.of(context).slideController2,
        ),
      ),
    ]);
  }

  
}

class addStoryCard extends StatefulWidget {
  addStoryCard({this.data, this.active, this.index, this.controller, this.kidId,this.userId});
  StoryData data;
  String kidId;
  bool active;
  PageController controller;
  int index;
  String userId;
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
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
    
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
                        print('YAHHHHHHHHH ${widget.userId}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addStoryPage(
                                      userId: widget.userId,
                                      data: widget.data,
                                      kidId: widget.kidId
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
      this.newest,
      this.kidId,
      this.userId});
  int index, current;
  bool active, newest;
  StoryData datas;
  Map data;
  bool exit;
  String kidId;
  PageController controller;
  String userId;
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
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    delController.dispose();
    super.dispose();
    

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
                                editStoryScreen(data: widget.data, kidId: widget.kidId, userId: widget.userId)));

                    if (remove == null) {
                      null;
                    } else if (remove) {
                      widget.datas.getAllStory().removeAt(widget.index);
                    }
                    storyPage.of(context).setIndex(widget.index);
                  }
                },
                child: ScaleTransition(
                    scale: animation,
                    child: Stack(children: <Widget>[
                      Hero(
                        tag: 'pic${widget.data['id']}',
                        child: Container(
                          margin: edgeAll(10),
                          decoration: ((widget.data['coverImg'] == null) | (widget.data['coverImg'] == 'image path'))
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
                                    image: (widget.data['coverImg'].runtimeType == String)
                                        ? NetworkImage(widget.data['coverImg'])
                                        : FileImage(widget.data['coverImg']),
                                    fit: BoxFit.cover,
                                  )),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: 50,
                        child: Text(
                          // widget.data['date'].toString(),
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
  newDate += month[date.month-1];
  newDate += ' ';
  newDate += date.year.toString();
  return newDate;
}

class childrenList extends StatefulWidget {
  childrenList(
      {this.index,
      this.img,
      this.name,
      this.controller,
      this.data,
      this.userId, Key key}):super(key:key);
  String img, name;
  String userId;
  int index;
  bool open;
  dataTest data;
  AnimationController controller;
  @override
  _childrenListState createState() => _childrenListState();
}

class _childrenListState extends State<childrenList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: edgeAll(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: GestureDetector(
                 onTap: () {
                   setState(() {
                     storyPage.of(context).update = true;
                   });
                  
                  storyPage.of(context).setFalse();
                  widget.controller.reverse();

                  // _kids.of(context).data.kiddo);
                  storyPage.of(context).setSelectedKid(widget.index + 1);
                  storyPage.of(context).slideController2.forward();
                  // storyPage.of(context).slideController.reverse();
                  // if (!storyPage.of(context).loading)
                  //   storyPage.of(context).slideController.forward();
                  print(storyPage.of(context).open);
                  // widget.data.setSelectedKid(widget.index);
                  //push new kid use push replacement
                },
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: 'child${widget.index}',
                      child: circleImg(
                        img: ((widget.img == null) | (widget.img == 'image path')) ? AssetImage('assets/icons/037-baby.png') : NetworkImage(widget.img),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(
                      '   ' + widget.name,
                    ),
                  ],
                )),
          ),
          // GestureDetector(
          //   onTap: () async {
          //     var remove = await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => editKidData(
          //                   index: widget.index,
          //                   data: widget.data.getKids()[widget.index],
          //                   userId: widget.userId,
          //                   dataList: widget.data,
          //                 )));
          //     if (remove == null) {
          //       null;
          //     } else {
          //       setState(() {
          //         widget.data.getKids().removeAt(widget.index);

          //         widget.data.setSelectedKidAny();
          //         // widget.data.getSelectedKid());
          //       });
          //       // widget.data.getKids().removeAt(widget.index);
          //     }
          //   },
          //   child: Icon(Icons.edit),
          // )
        ],
      ),
    );
  }
}


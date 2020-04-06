import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
class postPage extends StatefulWidget{
 @override
 _postPageState createState() => _postPageState();
}
 
class _postPageState extends State<postPage>{
@override
Widget build(BuildContext context){
  return CustomScrollView(
    slivers: <Widget>[
      
      SliverPersistentHeader(
        pinned: true,
        delegate: MySliverAppBar(maxHeight: 500, minHeight: 300, postBox: postBox()),
      ),
      
      
    
      SliverList(
        delegate: SliverChildListDelegate([
          
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top:80),
            child: Column(
              children: <Widget>[
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
                commentBox(),
              ],
            ),
          ),
        ]),
      )
    ],
  );
  }
}
 
 

 
class MySliverAppBar extends SliverPersistentHeaderDelegate {
 final double maxHeight,minHeight;
 Widget postBox;
 MySliverAppBar({@required this.maxHeight,@required this.minHeight,@required this.postBox});
 
 @override
 Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
   return LayoutBuilder(
     builder: (context, constraints){
       return Stack(
        
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 170),
            child: Image.network(
              "https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg",
              fit: BoxFit.cover
            ),
          ),
          
        
          Positioned(
            top: maxHeight -200- shrinkOffset < -30? -30 : maxHeight-shrinkOffset-200,
            left: 0,
            child: Container(
              
              decoration: new BoxDecoration(
                // boxShadow: [new BoxShadow(
                  
                //   )],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0) ),
              ),
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0) ),
              child: SizedBox(
                // height: 200,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  
                  decoration: dec(context),
                  child: postBox,
                ),
              ),
            )
          ),
          
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
dec(BuildContext context)=> BoxDecoration(color: Colors.white,borderRadius: new BorderRadius.only(topLeft: const Radius.circular(40.0),topRight: const Radius.circular(40.0)));


//CommentBox

class commentBox extends StatefulWidget{
  @override
  _commentBoxState createState() => _commentBoxState();

}
class _commentBoxState extends State<commentBox>{
  bool favoritePressed = false;
  bool commentPressed = false;
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )
        ),
      ),
      margin: EdgeInsets.only(left:20,right: 20),
      padding: EdgeInsets.all(20),
      child:Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            width: 50,
            height: 50,
            decoration: new BoxDecoration(
              
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("https://sketchok.com/images/articles/01-cartoons/002-family-guy/02/08.jpg")
              )
            ),       
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Mom1',textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                Text('kuay rai ka edok',textAlign: TextAlign.left,style: TextStyle(fontSize: 18),)
              ],
            )
          ),
          Container(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.comment),
                  color: Colors.pink,
                  onPressed: (){

                  },
                ),
                // SizedBox(
                //   width: 18,
                // ),
                IconButton(
                  icon: Icon(Icons.favorite),
                  
                  color: favoritePressed? Colors.pink : Colors.grey,
                  onPressed: (){
                    setState(() {
                      favoritePressed = ! favoritePressed;
                    });
                  },
                )
              ],
            )
          )
        ],
      )
    );
  }
}

class postBox extends StatefulWidget{
  @override
  _postBoxState createState() => _postBoxState();
}

var pheight;
class _postBoxState extends State<postBox>{
  final GlobalKey _postKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=> getHeight());
    
  }

  getHeight(){
    RenderBox _pBox = _postKey.currentContext.findRenderObject();
    print(_pBox.size.height);
    pheight = _pBox.size.height;
  }
  @override
  Widget build(BuildContext context){
    return Container( 
      key: _postKey,
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
                child: Container(
                  color: Colors.grey,
                ),
              ), 
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            child:Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 20),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage("https://sketchok.com/images/articles/01-cartoons/002-family-guy/02/08.jpg")
                    ),
                  ),
                ),
                Text("Anti Prayuth",style: TextStyle(fontSize: 20),)
              ],
            )
          
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.topLeft,
            child: Text('มีมฮาๆครับวันนี้'),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              border: Border.all(color:Color(0x878787).withAlpha(80)),
              boxShadow: [
                new BoxShadow(
                  spreadRadius: 1.0,
                  blurRadius: 1.0,
                  color: Color(0x878787).withAlpha(50)
                )
              ]
            ),
            
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
                            child: IconButton(
                              icon: Icon(Icons.favorite),
                              color: Colors.yellow,
                              onPressed: (){
                                
                              },
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text('999'),
                          )
                        ],
                      ),
                    ),
                    
                    Text('|'),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: favButton()
                          ),
                          Expanded(
                            child:Text('999k')
                          )
                          
                        ],
                      )
                    )
                    
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text('Comment',style: TextStyle(fontSize: 24),),
          )
        ],
      ),
    );
  }
}

class favButton extends StatefulWidget{
  @override
  _favButtonState createState() => _favButtonState();
}

class _favButtonState extends State<favButton>{
  bool _pressed = false;
  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(Icons.favorite),
      color: _pressed? Colors.pink : Colors.grey,
      onPressed: (){
        setState(() {
          _pressed = !_pressed;
        });
      },
    );
  }
}
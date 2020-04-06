import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';
import 'package:photo_view/photo_view.dart';

import 'commentdata.dart';

class mainPostScreen extends StatefulWidget{
  mainPostScreen({this.data});
  Map data;
  @override 
  _mainPostScreenState createState() => _mainPostScreenState();
}
class _mainPostScreenState extends State<mainPostScreen>{
  @override 
  Widget build(BuildContext context){
    return post(child: postPage(),data: widget.data,);
  }
}

class post extends StatefulWidget{
  Widget child;
  Map data;
  post({this.child,this.data});
  @override 
  _postState createState() => _postState();
  static _postState of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<inheritedPost>() as inheritedPost).data;
}
class _postState extends State<post>with TickerProviderStateMixin{
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
  @override 
  initState(){
    super.initState();
    slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    commentController = TextEditingController();
    commentNode = FocusNode();
    slideAnimation = Tween<Offset>(begin: Offset(0,0),end: Offset(0,0.5)).animate(CurvedAnimation(curve: Curves.easeInExpo,parent:slideController));
    scrollController = ScrollController();
    testUser = user.users[0];
    testPost = widget.data;
    // testComment = commentdata;
  }

  @override 
  dispose(){
    super.dispose();
    commentNode.dispose();
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
  addComment(int postID, int userID, String comment,){
    setState(() {
      var temp = {
        'postID':postID,
        // 'image':'https://pbs.twimg.com/profile_images/1168928962917097472/gD5uWGj3_400x400.jpg',
        'userID':userID,
        'comment':comment,
        'like':false
      };
      commentdata.comments.add(temp);
    });
  }
  @override 
  Widget build(BuildContext context){
    return inheritedPost(child: widget.child,data: this,);
  }
}
class inheritedPost extends InheritedWidget{
  final _postState data;

  const inheritedPost({@required Widget child,this.data}) : super(child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
  
}



class postPage extends StatefulWidget{
 @override
 _postPageState createState() => _postPageState();
}
 
class _postPageState extends State<postPage>{

@override
Widget build(BuildContext context){
  // post.of(context).commentdata.getComment(1);
  var image = post.of(context).testPost['image'];
  return Scaffold(
    body:ListView(
      padding: edgeAll(0),
      physics: BouncingScrollPhysics(),
      children:<Widget>[
    //     Container(
    //       height: MediaQuery.of(context).size.height - 100,
    //       color: Colors.white,
    //       child: Stack(
    //         children: <Widget>[
    //           Hero(
    //             tag:'pic',
    //             child:Image.network(
    //               image,
    //               fit: BoxFit.cover
    //             ),
    //           ),
    //           SizedBox.expand(
    //             child:SlideTransition(
    //             position: post.of(context).slideAnimation,
    //             child:DraggableScrollableSheet(
    //               minChildSize: 0.45,
    //               initialChildSize: 0.45,
    //               maxChildSize: 1,
    //               builder:(BuildContext context,ScrollController controller){
    //                 return SingleChildScrollView(
    //                   physics: BouncingScrollPhysics(),
    //                   controller: controller,
    //                   child: Container(
    //                     child: Column(
    //                       children: <Widget>[
    //                         Container(
    //                           decoration: new BoxDecoration(
    //                             borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0) ),
    //                           ),
    //                           // borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0) ),
    //                           child: SizedBox(
    //                             // height: 200,
    //                             width: MediaQuery.of(context).size.width,
    //                             child: Container(
                                  
    //                               decoration: dec(context),
    //                               child: postBox(),
    //                               )
    //                             ),
    //                           ),
    //                           Container(
    //                             height: MediaQuery.of(context).size.height - 180,
    //                             color: Colors.white,
    //                             child: ListView(
    //                               physics: BouncingScrollPhysics(),
    //                               padding: edgeAll(0),
    //                               controller: post.of(context).scrollController,
    //                               children:post.of(context).commentdata.getComment(post.of(context).testPost['id']).map((data)=>commentBox(data: data,)).toList()
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     )
    //                   );
    //                 }
    //               )
    //             )
    //           )
    //         ],
    //       ),
    //     ),

        Container(
          height: MediaQuery.of(context).size.height - 100,
          color: Colors.white,
          child:
          CustomScrollView(
            controller: post.of(context).scrollController,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              
              SliverPersistentHeader(
                pinned: true,
                delegate: MySliverAppBar(maxHeight: 500, minHeight: 300, postBox: postBox()),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 80,
                ),
              ),
              
            
              SliverList(
                delegate: SliverChildListDelegate(
                  post.of(context).commentdata.getComment(post.of(context).testPost['id']).map((data)=>commentBox(data: data,)).toList()
                  // Container(
                  //   color: Colors.white,
                  //   margin: EdgeInsets.only(top:80),
                  //   child: Column(
                  //     children: <Widget>[
                        


                  //     ],
                  //   ),
                  // ),
                ),
              )
            ],
          )
        ),
        selfComment()
        // Container(
        //   height: 100,
        //   color: Colors.red,
        //   child: Column(
        //     children: <Widget>[
        //       circleImg(img: '404.png',height: 50,width: 50,)
        //     ],
        //   ),
        // )
        
    //   ]
    // )
    
      ]
    )
    );
  }
}
 
 

 
class MySliverAppBar extends SliverPersistentHeaderDelegate {
 final double maxHeight,minHeight;
 Widget postBox;
 MySliverAppBar({@required this.maxHeight,@required this.minHeight,@required this.postBox});
 
 @override
 Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
  //  print(post.of(context).testPost);
   var image = post.of(context).testPost['image'];
   return LayoutBuilder(
     builder: (context, constraints){
       return Stack(
        
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 170),
            child: GestureDetector(
              onTap: ()async{
                post.of(context).forward();
                await Future.delayed(Duration(milliseconds: 100),()async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>pictureView(pic:image)));
                });
                await Future.delayed(Duration(milliseconds: 200),()async{
                  post.of(context).reverse();
                });
                post.of(context).commentNode.unfocus();
                
              },
              child: Hero(
                tag:'pic',
                child:Image.network(
                  image,
                  fit: BoxFit.cover
                ),
              )
            )
          ),
          
        
          Positioned(
            top: maxHeight -200- shrinkOffset < -30? -30 : maxHeight-shrinkOffset-200,
            left: 0,
            child: SlideTransition(
                    position: post.of(context).slideAnimation,
                    child:
            Container(
              
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
                  )
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
  commentBox({this.data});
  Map data;
  @override
  _commentBoxState createState() => _commentBoxState();

}
class _commentBoxState extends State<commentBox>{
  bool favoritePressed = false;
  bool commentPressed = false;
  @override
  Widget build(BuildContext context){
    return Container(
      // height: 100,
      width: MediaQuery.of(context).size.width,
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
      padding: edgeTB(20),
      child:Row(
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
                    image: new NetworkImage(post.of(context).user.getProfilePic(widget.data['userID']))
                  )
                ),       
              ),
              Container(
                // width: MediaQuery.of(context).size.width - 100,
                // height: 200,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 170,
                  minWidth: MediaQuery.of(context).size.width - 170
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(post.of(context).user.getProfileName(widget.data['userID']),textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                    Divider(),
                    Text(widget.data['comment'],textAlign: TextAlign.left,style: TextStyle(fontSize: 16),)
                  ],
                )
              ),
            ],
          ),
          Container(
            height: 50,
            width: 50,
            child:favButton(like:widget.data['like'],editable: true)
          )
          
        ],
      )
    );
  }
}

class postBox extends StatefulWidget{
    Map data;
  postBox({this.data});
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
    img(){
      if(widget.data != null){
        if((widget.data['profileImg'] == null) | (widget.data['profileImg'] == '')){
          return AssetImage('assets/icons/404.png');
        }
        else{
          return NetworkImage(widget.data['profileImg']);
        }
      }
      return AssetImage('assets/icons/404.png');
    }

    name(){
      if(widget.data != null){
        if((widget.data['profileName'] == null) | (widget.data['profileName'] == '')){
          return Text('Null');
        }
        else{
          return Text(widget.data['profileName']);
        }
      }
      return Text('Null');
    }
    words(){
      if(widget.data != null){
        if((widget.data['postWord'] == null) | (widget.data['postWord'] == '')){
          return Text('Null');
        }
        else{
          return Text(widget.data['postWord']);
        }
      }
      return Text('Null');
    }
    likes(){
      if(widget.data != null){
        return widget.data['like'];
      }
      return false;
    }
    return Container( 
      key: _postKey,
      constraints: BoxConstraints(
        maxHeight: 281,
        minHeight:281
      ),
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
                      image: img()
                    ),
                  ),
                ),
                name()
              ],
            )
          
          ),

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
                            child: favButton(like: likes(),editable: true,)
                          ),
                          Expanded(
                            flex: 4,
                            child: Text('EDIT HERE'),
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
                            child: commentButton()
                          ),
                          Expanded(
                            child:Text('EDIT HERE')
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
  favButton({this.like,this.editable});
  bool like;
  bool editable;
  @override
  _favButtonState createState() => _favButtonState();
}

class _favButtonState extends State<favButton>{
  bool _pressed = false;
  @override
  Widget build(BuildContext context){
    getLike(){
      return widget.like;
    }
    setLike(){
      widget.like = !widget.like;
    }
    return IconButton(
      icon: getLike() ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      color:Colors.pink,
      onPressed: (){
        if(widget.editable){
          setState(() {
            setLike();
          });
        }
      },
    );
  }
}
class commentButton extends StatefulWidget{
  @override
  _commentButtonState createState() => _commentButtonState();
}

class _commentButtonState extends State<commentButton>{
  bool _pressed = false;
  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(Icons.comment),
      color:Colors.pink,
      onPressed: (){
        setState(() {
          // print(post.of(context));
          // print('eiei');
          post.of(context);
        });
      },
    );
  }
}

class pictureView extends StatefulWidget{
  pictureView({this.pic});
  String pic;
  @override 
  _pictureViewState createState() => _pictureViewState();
}
class _pictureViewState extends State<pictureView>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: PhotoView(
        heroAttributes: PhotoViewHeroAttributes(tag: 'pic'),
        imageProvider: NetworkImage(widget.pic),
      ),
    );
  }
}

class selfComment extends StatefulWidget{
  @override 
  _selfCommentState createState() => _selfCommentState();
}
class _selfCommentState extends State<selfComment>{
  // TextEditingController commentController;
  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    // commentController = TextEditingController();
  }
  @override 
  Widget build(BuildContext context){
    // images(){
    //   if(post.of(context).)
    // }
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [BoxShadow(blurRadius: 10,spreadRadius: 1,color: Color(0xff999999))]
      ),
      alignment: Alignment.center,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          circleImg(img: '404.png',height: 50,width: 50,),
          Container(
            width: 200,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                // focusedBorder: InputBorder.,
                // focusColor: Colors.transparent,
                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
              focusNode: post.of(context).commentNode,
              controller: post.of(context).commentController,
            ),
          ),
          GestureDetector(
            onTap: (){
              if(post.of(context).commentController.text != ''){
                post.of(context).addComment(post.of(context).testPost['id'], post.of(context).testUser['userID'],post.of(context).commentController.text );
                post.of(context).commentController.text = '';
                post.of(context).scrollController.animateTo(post.of(context).scrollController.position.maxScrollExtent + 100, duration: Duration(milliseconds: 500), curve: Curves.easeInOutExpo);
              }
            },
            child:Container(
              width: 50,
              height: 50,
              child: Icon(Icons.send),

            )
          )
        ],
      )
    );
  }
}
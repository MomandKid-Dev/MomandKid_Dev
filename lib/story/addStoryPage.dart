import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/shared/circleImg.dart';
import 'package:momandkid/shared/style.dart';
import 'package:momandkid/story/editStory.dart';
import 'package:momandkid/story/storyData.dart';
import 'carousel.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart';

class addStoryPage extends StatefulWidget{
  addStoryPage({this.data});
  int _pageIndex = 0;
  StoryData data;
  PageController controller = new PageController(initialPage: 0);
  @override 
  _addStory createState() => _addStory();
}

class _addStory extends State<addStoryPage>{
    
  coverImages ci = new coverImages();

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Color(0xff9CCBFF),
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.light // status bar color
    // ));
  }
  @override 
  Widget build(BuildContext context){
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children:<Widget>[
        
        Hero(
          tag:'addStory',
          child:Container(
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: gradientBackground()
            ),
            padding: edgeAll(20),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.transparent,
              body: Wrap(
                children:<Widget>[
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment,
                    children: <Widget>[
                      
                      Container(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          // getImage();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 30,
                          alignment: Alignment.centerRight,
                          child: Image.asset('assets/icons/ic_clear_24px.png',),
                        ),
                      ),
                      

                      
                      Container(
                        alignment: Alignment.center,
                        height: 80,
                        width: 80,
                        // color: Colors.red,
                        child:circleImg(img:'037-baby.png',height: 80,width: 80,),
                        
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      dates(controller: widget.controller,data: widget.data,)
                    ],
                  ),
                ]
              )
            ),
          )
        ),
        
      ]
    );
  }
}


button(String title,PageController controller,int index){
  return GestureDetector(
    onTap: (){
      controller.animateToPage(index+1,duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    },
    child: Container(
      width:220,
      padding: edgeAll(20),
      decoration: BoxDecoration(
        borderRadius: allRoundedCorner(40),
        color: Colors.white,
        boxShadow: shadow(2.0)
      ),
      child: Text(title,textAlign: TextAlign.center,),
    ),
  );
}

upbutton(String title,PageController controller,int index,File img){
  
  return GestureDetector(
    onTap: (){
      // return _openFileExplorer()
      // getImg;
      // getImage();
      File _image;
      Future getImage() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        _image = image;
        img = image;
        // img = image;
        // ci.setImg(_image);
      }
    },
    child: Container(
      width:220,
      padding: edgeAll(20),
      decoration: BoxDecoration(
        borderRadius: allRoundedCorner(40),
        color: Colors.white,
        boxShadow: shadow(2.0)
      ),
      child: Text(title,textAlign: TextAlign.center,),
    ),
  );
}

class dates extends StatefulWidget{
  dates({this.controller,this.data});
  PageController controller;
  StoryData data;
  int index;
  coverImages ci;
  @override 
  _dateState createState() => _dateState();
}

class _dateState extends State<dates>{
  var _image;
  int selectedMonth = DateTime.now().month, selectedDay=  DateTime.now().day;
  TextEditingController textController = TextEditingController();
  Future getImageFromGallery() async {
 
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
 
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height - 220,
      child:PageView(
        scrollDirection: Axis.horizontal,
        controller: widget.controller,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Ready to create a new story ?',style: TextStyle(fontSize: 22,color: Colors.white),),
              // pickDate(d.getMonth(), d.getDay()),
              carousel(selectedMonth:selectedMonth,selectedDay: selectedDay,),
              
              button('LET\'S DO IT',widget.controller,0)
            ],
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Give your story a title',style: TextStyle(fontSize: 22,color: Colors.white),),
              // pickDate(d.getMonth(), d.getDay()),
              
              TextField(
                maxLength: 60,
                controller: textController,
                style: TextStyle(fontSize: 30,color: Colors.white),
                decoration: InputDecoration(
                  
                  helperText: 'STORY TITLE',
                  helperStyle: TextStyle(fontSize: 16,color: Color.fromRGBO(255, 255, 255, 0.6)),
                  // hintMaxLines: 2,
                  hintText: 'Add title ...',
                  hintStyle: TextStyle(fontSize: 30,color: Colors.white.withAlpha(990)),
                  border: InputBorder.none,
                  // counterText: '',
                  
                ),
              ),
            
              button('LET\'S DO IT',widget.controller,1)
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Give your story a cover Picture',style: TextStyle(fontSize: 22,color: Colors.white),),
              // pickDate(d.getMonth(), d.getDay()),
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  ClipRRect(
                    // clipBehavior: Clip.hardEdge
                    borderRadius: BorderRadius.circular(30),
                    child:Container(
                      decoration: BoxDecoration(
                        borderRadius: allRoundedCorner(30),
                        color: Colors.white,
                        
                      ),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            child:Container(
                              color: Color(0xffF2C7C7),
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: _image == null ?   null : Image.file(_image,fit: BoxFit.cover,),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                height: 80,
                              ),
                              Container(
                                height: 50,
                                child:Wrap(
                                  direction: Axis.horizontal,
                                  children:<Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: ()async{
                                            //print(_image);
                                            print(toDate(selectedMonth, selectedDay));
                                            widget.data.addStory(widget.data.getAllStory().length , textController.text, _image, [], textController.text,toDate(selectedMonth, selectedDay));
                                            //print(widget.data.datas);
                                            var remove = await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                              
                                              return editStoryScreen(data:widget.data.getStory(widget.data.getAllStory().length-1));}));
                                            if(remove == null){
                                              null;
                                            }
                                            else if(remove == true){
                                              widget.data.getAllStory().removeAt(widget.data.getAllStory().length-1);
                                            }
                                          },
                                          child:Image.asset('assets/icons/check.png'),
                                        ),
                                        GestureDetector(
                                          child:Image.asset('assets/icons/close.png')
                                        )
                                        // Icon()
                                      ],
                                    )
                                  ]
                                )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 3 - 30,
                    child: GestureDetector(
                      onTap: (){
                        getImageFromGallery();
                        
                      },
                      child: Container(
                        width:220,
                        padding: edgeAll(20),
                        decoration: BoxDecoration(
                          borderRadius: allRoundedCorner(40),
                          color: Colors.white,
                          boxShadow: shadow(2.0)
                        ),
                        child: Text('eiei',textAlign: TextAlign.center,),
                      ),
                    )
                  )
                  
                ],
                    
              ),
            
              // button('LET\'S DO IT',controller,2)
            ],
          ),

          
        ]
      )
    );
  }
}



dateList(String item){
  return Container(
    child:Text(item)
  );
}

class coverImages{
  var src;
  getImg(){
    return src;
  }
  setImg(File img){
    this.src = img;
  }
}

// toDate(String date){
//   String newDate = '';
//   List month = ['January','February','March','May','June','July','August','September','October','November','December'];
//   newDate += date.substring(0,2);
//   newDate += ' ';
//   newDate += month[int.parse(date.substring(2,3))];
//   newDate += ' ';
//   newDate += date.substring(4,8);
//   return newDate;
// }

toDate(int month,int day){
  String newDate = '';
  if(day < 10){
    newDate += '0';
    newDate += day.toString();
  }
  else{
    newDate += day.toString();
  }
  if(month < 10){
    newDate += '0';
    newDate += month.toString();
  }
  else{
    newDate += month.toString();
  }
  
  newDate += DateTime.now().year.toString();
  return newDate;
}

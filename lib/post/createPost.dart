import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class createPost extends StatefulWidget {
  @override
  _createPostState createState() => _createPostState();
}

class _createPostState extends State<createPost> {

  File _image;
  TextEditingController _content;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
  Future takePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _content = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close), 
          iconSize: 36,
          color: Color(0xFFFF7572),
          onPressed: (){ Navigator.pop(context); }
          ),
        actions: <Widget>[
          _image == null ? FlatButton(
            onPressed: null, 
            child: Text(
              'post', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              )
            ):
          FlatButton(
            onPressed: (){ 
              print(_content.text);
              if(_content.text == ''){
                _content.text = ' ';
              }
              Navigator.pop(context, [_image, _content.text]); 
              }, 
            child: Text(
              'post', 
              style: TextStyle(
                color: Color(0xFFFF7572),
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              )
            )
            
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top:15),
        child: ListView(
          children: <Widget>[
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left:20),
              child: Text(
                'โพสต์ใหม่',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF707070)
                ),
              ),
            ),
            SizedBox(height: 12,),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
            ),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.width/3*2,
              width: MediaQuery.of(context).size.width,
              color: _image == null ? Colors.grey[300] : Colors.white,
              child: FlatButton(
                onPressed: getImage, 
                child: _image == null ? Center(child: Icon(Icons.add_circle, size: 80, color: Colors.grey[400],),) : 
                  Image.file(_image, fit: BoxFit.fitHeight,)
                ),
            ),
            SizedBox(height: 16,),
            // Container(
            //   height: 30,
            //   width: MediaQuery.of(context).size.width,
            //   padding: EdgeInsets.only(left: 20, right: 20),
            //   child: Row(
            //     children: <Widget>[
            //       Text(
            //         'Tag : ',
            //         style: TextStyle(
            //           fontSize: 21,
            //           fontWeight: FontWeight.normal,
            //           color: Color(0xFF707070) 
            //         ),
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width*0.755,
            //         child: TextField(
            //           decoration: InputDecoration(
            //             border: InputBorder.none
            //           ),
            //           inputFormatters: [
            //             WhitelistingTextInputFormatter(RegExp("[A-Za-z ]")),
            //             LengthLimitingTextInputFormatter(26),
            //           ],
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.normal,
            //             color: Color(0xFF707070) 
            //           ),
            //         ),
            //       )
            //     ],
            //   )
            // ),
            SizedBox(height: 16,),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
            ),
            SizedBox(height: 12,),
            Container(
              height: MediaQuery.of(context).size.width*9/18,
              width: MediaQuery.of(context).size.width,
              // color: Colors.grey[300],
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: _content,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'คำบรรยาย...',
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 21
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.075,
              width: MediaQuery.of(context).size.width,
              child: FlatButton(onPressed: takePicture, child: Center( child: Icon(Icons.camera_alt, color: Color(0xFFFF7572), size: 36,))),
            ),
          ],
        )
      )
    );
  }
}
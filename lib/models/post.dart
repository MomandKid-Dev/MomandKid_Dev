import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  final String content;
  final String image;
  final Timestamp time;
  final String uid;
  final int likecount;
  final String username;
  final String userprofile;
  

  Post({this.content,this.image,this.time,this.uid,this.likecount,this.username,this.userprofile});

}
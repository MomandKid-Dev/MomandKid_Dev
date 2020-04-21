import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

  final String pid;
  final String content;
  final String image;
  final Timestamp time;
  final String uid;
  final int likecount;
  final int commentcount;
  final String username;
  final String userprofile;
  final List<dynamic> likes;
  

  Post({this.pid,this.content,this.image,this.time,this.uid,this.likecount,this.commentcount,this.username,this.userprofile,this.likes});

}
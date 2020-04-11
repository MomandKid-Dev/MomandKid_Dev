import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  final String cid;
  final String content;
  final Timestamp time;
  final String username;
  final String userprofile;
  

  Comment({this.cid,this.content,this.time,this.username,this.userprofile});

}
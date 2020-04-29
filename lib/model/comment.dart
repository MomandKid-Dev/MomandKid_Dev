import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  final String cid;
  final String content;
  final Timestamp time;
  final String uid;
  final String username;
  final String userprofile;


  Comment({this.cid,this.content,this.time,this.uid,this.username,this.userprofile});

  Map getMap() {
    Map comment = {};
    comment['cid'] = this.cid;
    comment['content'] = this.content;
    comment['time'] = this.time;
    comment['uid'] = this.uid;
    comment['username'] = this.username;
    comment['userprofile'] = this.userprofile;
    return comment;
  }

}
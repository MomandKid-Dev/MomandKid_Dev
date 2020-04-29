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
  final bool liked;
  

  Post({this.pid,this.content,this.image,this.time,this.uid,this.likecount,this.commentcount,this.username,this.userprofile,this.likes,this.liked});

  Map getMap() {
    Map post = {};
    post['pid'] = this.pid;
    post['content'] = this.content;
    post['image'] = this.image;
    post['time'] = this.time;
    post['uid'] = this.uid;
    post['likecount'] = this.likecount;
    post['commentcount'] = this.commentcount;
    post['username'] = this.username;
    post['userprofile'] = this.userprofile;
    post['likes'] = this.likes;
    post['liked'] = this.liked;
    return post;
  }
}
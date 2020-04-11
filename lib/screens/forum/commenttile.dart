import 'package:flutter/material.dart';
import 'package:momandkid/models/comment.dart';
import 'package:momandkid/services/database.dart';
import 'package:provider/provider.dart';
import 'package:momandkid/models/user.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  CommentTile({this.comment});
  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[400],
          ),
        title: Text(widget.comment.username),
        subtitle: Text(widget.comment.content),
      ),
    );
  }
}
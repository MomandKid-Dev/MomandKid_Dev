import 'package:flutter/material.dart';
import 'package:momandkid/models/post.dart';
import 'package:momandkid/services/database.dart';
import 'package:provider/provider.dart';
import 'package:momandkid/models/user.dart';


class PostTile extends StatefulWidget {
  final Post post;
  PostTile({this.post});
  @override
  _PostTileState createState() => _PostTileState();
}



class _PostTileState extends State<PostTile> {

  String content = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey[400],
                ),
              title: Text(widget.post.username),
              subtitle: Text(widget.post.content),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Comment'),
              onChanged: (val) {
                setState(() => content = val);
              },
            ),
            RaisedButton(
              onPressed: () async {
                await DatabaseService(uid: user.uid)
                .createComment(widget.post.pid, content);
              },
              child: Text('Send'),
            )
          ],
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:momandkid/models/post.dart';
import 'package:momandkid/services/database.dart';
import 'package:provider/provider.dart';
import 'package:momandkid/models/user.dart';
import 'package:momandkid/models/comment.dart';
import 'package:momandkid/screens/forum/commenttile.dart';
import 'package:quiver/iterables.dart';


class PostTile extends StatefulWidget {
  final Post post;
  PostTile({this.post});
  @override
  _PostTileState createState() => _PostTileState();
}


final db = DatabaseService();

Future getComments(List<String> commentsId) async { 
  return await Future.wait(commentsId.map((comment)=>db.getCommentData(comment)));
}

Future getUsers(List<dynamic> comments) async {
  return await Future.wait(comments.map((comment)=>db.getUserFromComment(comment)));
}

List<Comment> _commentFromFirebaseComment(AsyncSnapshot comments,AsyncSnapshot users){
   List<Comment> commentss = [];
   for (List<dynamic> cu in zip([comments.data,users.data])){
     commentss.add(
      Comment(
        cid: cu[0].documentID,
        content: cu[0].data['content'] ?? '',
        time: cu[0].data['time'] ?? null,
        username: cu[1].data['name'] ?? '',
        userprofile: cu[1].data['image'] ?? ''
      )
    );
  }
  return commentss;
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: FutureBuilder(
                        future: DatabaseService().getCommentFromPost(widget.post.pid),
                        builder: (BuildContext context, AsyncSnapshot commentLocateSnapshot){
                          if (commentLocateSnapshot.hasError) return Text('Error: ${commentLocateSnapshot.error}');
                          switch (commentLocateSnapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Text('Loading..');
                          default:
                            if (commentLocateSnapshot.data.data == null) {
                              return Text('No Comment Available');
                            }
                            else{
                              return FutureBuilder(
                                future: getComments(commentLocateSnapshot.data.data.keys.toList()),
                                builder: (BuildContext context, AsyncSnapshot commentSnapshot){
                                  if (commentSnapshot.hasError) return Text('Error: ${commentSnapshot.error}');
                                  switch (commentSnapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text('Loading...');
                                  default:
                                    return FutureBuilder(
                                      future: getUsers(commentSnapshot.data),
                                      builder: (BuildContext context, AsyncSnapshot userSnapshot){
                                        if (userSnapshot.hasError) return Text('Error: ${userSnapshot.error}');
                                        switch (userSnapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Text('Loading....');
                                        default:
                                          return Container(
                                            height: 300.0,
                                            width: 300.0,
                                            child: ListView.builder(
                                              itemCount: commentSnapshot.data.length,
                                              itemBuilder: (context, index){
                                                return CommentTile(
                                                  comment: _commentFromFirebaseComment(commentSnapshot, userSnapshot)[index],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                }
                              );
                            }
                          }
                        }
                      ),
                    );
                  }
                );
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.grey[400],
                  ),
                title: Text(widget.post.username),
                subtitle: Text(widget.post.content),
                ),
              )
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
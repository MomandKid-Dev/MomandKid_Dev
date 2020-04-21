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

  String _content = '';
  int _comments = 0;
  int _likes = 0;
  bool likestate = false;
  final TextEditingController _textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
    _comments = widget.post.commentcount;
    _likes = widget.post.likecount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (widget.post.likes.contains(user.uid)) likestate = true;
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
                trailing: Column(
                  children: <Widget>[
                    SizedBox(height: 10,width: 10,),
                    Text('likes : $_likes'),
                    Text('comments : $_comments'),
                  ],
                ),
              ),
            )
          ),
          Row(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  height: 50.0,
                  width: 150.0,
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Comment'),
                    keyboardType: TextInputType.text,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Enter Comment First';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => _content = val);
                    },
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String completeComment = _content;
                    _textController.clear();
                    setState(() {
                      _comments++;
                    });
                    await DatabaseService(uid: user.uid)
                    .createComment(widget.post.pid, completeComment);
                  }
                },
                child: Text('Send'),
              ),
              SizedBox(height: 50.0,width: 10.0,),
              RaisedButton(
                onPressed: () async {
                  if (likestate){
                    setState(() {
                      _likes--;
                    });
                    await DatabaseService(uid: user.uid)
                    .removeLike(widget.post.pid);
                  }
                  else{
                    setState(() {
                      _likes++;
                    });
                    await DatabaseService(uid: user.uid)
                    .createLike(widget.post.pid);
                  }
                  likestate = !likestate;
                },
                child: Text('Like'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
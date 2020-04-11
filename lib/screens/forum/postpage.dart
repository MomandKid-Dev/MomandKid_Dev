import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momandkid/screens/forum/posttile.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/models/post.dart';
import 'package:quiver/iterables.dart';
import 'package:momandkid/services/auth.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

final _auth = AuthService();
final db = DatabaseService();
final int quantity = 10;

List<DocumentSnapshot> postRetrieved;
List<DocumentSnapshot> userFromPost;

List<Post> _postFromFirebasePost(AsyncSnapshot posts,AsyncSnapshot users){
   List<Post> postss = [];
   for (List<dynamic> pu in zip([posts.data.documents,users.data])){
     postss.add(
      Post(
        pid: pu[0].documentID,
        content: pu[0].data['content'] ?? '',
        image: pu[0].data['image'] ?? '',
        time: pu[0].data['time'] ?? null,
        uid: pu[0].data['uid'] ?? '',
        likecount: pu[0].data['likecount'] ?? 0,
        username: pu[1].data['name'] ?? '',
        userprofile: pu[1].data['image'] ?? ''
      )
    );
  }
  return postss;
}

Future getUsers(List<DocumentSnapshot> posts) async {
  return await Future.wait(posts.map((post)=>db.getUserFromPost(post)));
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService().getPostData(quantity),
      builder: (BuildContext context, AsyncSnapshot postSnapshot){
      if (postSnapshot.hasError) return Text('Error: ${postSnapshot.error}');
      switch (postSnapshot.connectionState) {
      case ConnectionState.waiting:
        return Text('Loading...');
      default:
        return FutureBuilder(
          future: getUsers(postSnapshot.data.documents),
          builder: (BuildContext context, AsyncSnapshot userSnapshot) {
            if (userSnapshot.hasError) return Text('Error: ${userSnapshot.error}');
            switch (userSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  backgroundColor: Colors.grey[400],
                  elevation: 0.0,
                  title: Text('Posts Page'),
                  leading: RaisedButton(
                    child: Text('SignOut'),
                    onPressed: ()async {await _auth.signOut();},
                  ),
                ),
                body: 
                ListView.builder(
                  itemCount: postSnapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return PostTile(
                      post: _postFromFirebasePost(postSnapshot, userSnapshot)[index],
                    );
                  }
                )
              );
            }
          }
        );
      }
    });
  }
}


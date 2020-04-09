import 'package:flutter/material.dart';
import 'package:momandkid/models/user.dart';
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/services/database.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

// backend
  final AuthService _auth = AuthService();

// text field state
  String content = '';
  String error = '';


class _CreatePostState extends State<CreatePost> {

  Widget _buildPostField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Write Somethin\''),
      keyboardType: TextInputType.text,
      validator: (String val) {
        if (val.isEmpty) {
          return 'Write Something!';
        }

        return null;
      },
      onChanged: (val) {
        setState(() => content = val);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        elevation: 0.0,
        title: Text('Create your Post'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            _buildPostField(),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('post'),
              onPressed: () async {
                DatabaseService(uid: user.uid)
                .createPost(content,'image path');
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('exit'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
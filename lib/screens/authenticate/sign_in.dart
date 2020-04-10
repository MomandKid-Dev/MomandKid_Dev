// import libraries
import 'package:flutter/material.dart';

// import files
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/models/user.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  User _user = User();
  String error = '';

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String val) {
        if (val.isEmpty) {
          return 'Enter an email';
        }

        return null;
      },
      onChanged: (val) {
        setState(() => _user.email = val);
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Password'),
      obscureText: true,
      validator: (String val) {
        if (val.length < 6) {
          return 'Enter a password more 6 charactors';
        }

        return null;
      },
      onChanged: (val) {
        setState(() => _user.password = val);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 100.0,
              ),
              SizedBox(height: 20.0),
              _buildEmailField(),
              SizedBox(height: 20.0),
              _buildPasswordField(),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.teal,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.signInWithEmailAndPassword(
                        _user.email, _user.password);
                    if (result == null) {
                      setState(() => error = 'Email or Passeord incorrect');
                    } else {
                      print(result.uid);
                    }
                  }
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Icon(Icons.person),
                onPressed: () {
                  widget.toggleView();
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.redAccent, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

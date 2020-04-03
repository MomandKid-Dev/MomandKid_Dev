// import libraries
import 'package:flutter/material.dart';

// import files
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/models/user.dart';
import 'package:momandkid/screens/createbaby_info/baby_name.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  // text field state
  User _user = User();
  String error = '';

  // widget
  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Display name'),
      keyboardType: TextInputType.text,
      validator: (String val) {
        if (val.isEmpty) {
          return 'Please enter your name';
        }

        return null;
      },
      onChanged: (val) {
        setState(() => _user.name = val);
      },
    );
  }

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
      controller: _passwordController,
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

  Widget _buildConfirmPassword() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Confirm Password'),
      obscureText: true,
      validator: (String val) {
        if (_passwordController.text != val) {
          return 'Password not math';
        }

        return null;
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: 100.0,
                ),
                SizedBox(height: 20.0),
                _buildDisplayNameField(),
                SizedBox(height: 20.0),
                _buildEmailField(),
                SizedBox(height: 20.0),
                _buildPasswordField(),
                SizedBox(height: 20.0),
                _buildConfirmPassword(),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          _user.name, _user.email, _user.password);
                      if (result == null) {
                        setState(() => error = 'please supply a valid email');
                      } else {
                        print('create baby info');
                        BabyName();
                      }
                    }
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Icon(Icons.arrow_back_ios),
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
      ),
    );
  }
}

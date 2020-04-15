import 'package:flutter/material.dart';
import 'package:momandkid/kids/addkid.dart';
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/services/database.dart';
import 'package:momandkid/kids/DataTest.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.loginCallback});

  final AuthService auth;
  final VoidCallback loginCallback;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  String _name;
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;
  bool _isLoginForm;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_name, _email, _password);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => mainAddScreen(
                      userId: userId,
                    )),
          );
          print('Signed up: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          print('Login complete');
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      print('Loading out');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showConfirmPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
          child: FlutterLogo(
            size: 100.0,
          )),
    );
  }

  Widget showNameInput() {
    if (_isLoginForm) {
      return Container(
        height: 85.0,
        width: 0.0,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Name',
              icon: Icon(
                Icons.person_pin,
                color: Colors.grey,
              )),
          validator: (val) => val.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (val) => _name = val,
        ),
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (val) => val.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (val) => _email = val.trim(),
        ));
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        controller: _passwordController,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (val) => val.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (val) => _password = val.trim(),
      ),
    );
  }

  Widget showConfirmPasswordInput() {
    if (_isLoginForm) {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Password',
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (val) {
            if (_passwordController.text != val) {
              return 'Password not math';
            }
            return null;
          },
          onSaved: (val) => _password = val.trim(),
        ),
      );
    }
  }

  Widget showPrimaryButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(
              _isLoginForm ? 'Login' : 'Create account',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
      onPressed: toggleFormMode,
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }
}

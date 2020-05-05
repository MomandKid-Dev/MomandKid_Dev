import 'package:flutter/material.dart';
import 'package:momandkid/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:momandkid/kids/addkid.dart';
import 'package:momandkid/services/auth.dart';
import 'package:momandkid/kids/DataTest.dart';
import 'dart:async';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class mainLogin extends StatefulWidget {
  mainLogin({this.auth, this.loginCallback, this.data});

  final AuthService auth;
  final VoidCallback loginCallback;
  dataTest data;

  @override
  _mainLoginState createState() => _mainLoginState();
}

String _title = 'Login'; //default

class _mainLoginState extends State<mainLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF9AB3), Color(0xFF9CCBFF)])),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: CustomBottomSheet(
            auth: widget.auth,
            loginCallback: widget.loginCallback,
            data: widget.data),
      ),
    );
  }
}

class StateBloc {
  StreamController animationController = StreamController();
  final StateProvider provider = StateProvider();

  Stream get animationStatus => animationController.stream;

  void toggleAnimation() {
    provider.toggleAnimationValue();
    animationController.sink.add(provider.isAnimating);
  }

  void dispose() {
    animationController.close();
  }
}

final stateBloc = StateBloc();

class StateProvider {
  bool isAnimating = true;
  void toggleAnimationValue() => isAnimating = !isAnimating;
}

class CustomBottomSheet extends StatefulWidget {
  CustomBottomSheet({this.auth, this.loginCallback, this.data});

  final AuthService auth;
  final VoidCallback loginCallback;
  dataTest data;

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
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

  void validateWithFacebook() async {
    String userId = "";
    userId = await widget.auth.loginWithFacebook();
    dynamic info;
    await Database(userId: userId)
        .getUserData()
        .then((onValue) => info = onValue.data);
    if (info['amount-baby'] == 0) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => mainAddScreen(
                  userId: userId,
                  data: widget.data,
                )),
      );
      print('Signed up: $userId');
    } else {
      print('Signed in: $userId');
    }
    setState(() {
      _isLoading = false;
    });
    if (userId.length > 0 && userId != null) {
      print('Login complete');
      widget.loginCallback();
    }
  }

  void validateWithGoogle() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    print('google Login');
    String userId = "";
    try {
      userId = await widget.auth.signInWithGoogle();
      dynamic info;
      await Database(userId: userId).getUserData().then((val) {
        info = val.data;
      });
      if (info['amount-baby'] == 0) {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => mainAddScreen(
                    userId: userId,
                    data: widget.data,
                  )),
        );
      }
      print('Signed up: $userId');

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
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => mainAddScreen(
                      userId: userId,
                      data: widget.data,
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

  double loginLeft = 0;
  double signupLeft = 101;

  Animation<double> animation, animationHorizontal;
  AnimationController controller;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
    setAnimation(0, 140);
  }

  void setAnimation(double sheetTop, double minSheetTop) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
    animationHorizontal = Tween<double>(begin: loginLeft, end: signupLeft)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  forwardAnimation() {
    controller.forward(from: 0);
    print(animation.value);
    stateBloc.toggleAnimation();
    _title = 'Sign up';
  }

  reverseAnimation() {
    controller.reverse(from: 1);
    print(animation.value);
    stateBloc.toggleAnimation();
    _title = 'Login';
  }

  bool isExpanded = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = 'Log in/out by pressing the buttons below.';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: <Widget>[
        Positioned(
          top: SizeConfig.blockSizeVertical * 16,
          left: SizeConfig.blockSizeHorizontal * 27,
          child: Image.asset(
            'assets/icons/020-hat.png',
            scale: 0.65,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3.5,
          left: 0,
          child: SheetContainer(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3.5 + animation.value,
          left: 0,
          child: SheetContainer(),
        ),
        Positioned(
            top: SizeConfig.blockSizeVertical * 25.5,
            left: SizeConfig.blockSizeHorizontal * 24,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Color(0xFFFFDAAA)),
            )),
        Positioned(
            top: SizeConfig.blockSizeVertical * 25.5,
            left: SizeConfig.blockSizeHorizontal * 52,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  color: Color(0xFFFFE3C2)),
            )),
        Positioned(
          top: animation.value + (MediaQuery.of(context).size.height) / 1.535,
          left: (MediaQuery.of(context).size.width) / 6,
          child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFF5EA0FF),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50), right: Radius.circular(50))),
              padding: EdgeInsets.only(top: 6),
              child: FlatButton(
                onPressed: validateAndSubmit,
                child: Text(
                  _title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 34.5,
          left: (MediaQuery.of(context).size.width) / 7,
          child: Container(
            height: 50,
            width: 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50), right: Radius.circular(50)),
                color: Color(0xFFEAD4E7)),
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 34.8,
          left: ((MediaQuery.of(context).size.width) / 6.5) +
              animationHorizontal.value, //45->146

          child: Container(
            height: 45,
            width: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50), right: Radius.circular(50)),
                color: Colors.white),
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 35.5,
          left: (MediaQuery.of(context).size.width) / 5.15,
          child: Container(
            height: 40,
            width: 80,
            child: Text(
              'Login',
              style: TextStyle(
                  color:
                      controller.isCompleted ? Colors.white : Color(0xFF131048),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 35.5,
          left: (MediaQuery.of(context).size.width) / 2.36,
          child: Container(
            height: 40,
            width: 100,
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color:
                      controller.isCompleted ? Color(0xFF131048) : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  wordSpacing: -5),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          //TextArea
          top: MediaQuery.of(context).size.height / 2.6,
          child: Container(
              height: _title == 'Login'
                  ? MediaQuery.of(context).size.height / 3.9
                  : MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width - 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.transparent,
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      showNameInput(),
                      showEmailInput(),
                      showPasswordInput(),
                      showConfirmPasswordInput(),
                      showErrorMessage(),
                    ],
                  ))),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 34.5,
          left: (MediaQuery.of(context).size.width) / 7,
          child: Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50), right: Radius.circular(50)),
                  color: Colors.transparent),
              child: GestureDetector(
                onTap: () {
                  controller.isCompleted
                      ? reverseAnimation()
                      : forwardAnimation();
                  toggleFormMode();
                },
              )),
        ),
        _title == 'Login'
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: FlatButton(
                            onPressed: () {
                              TextEditingController email =
                                  TextEditingController();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)), //this right here
                                      child: Container(
                                        height: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Forget Password?',
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextField(
                                                controller: email,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        'Enter your E-mail'),
                                              ),
                                              SizedBox(
                                                width: 320.0,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    widget.auth.resetPassword(
                                                        email.text);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color:
                                                      const Color(0xFF1BC0C5),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Align(
                        alignment: Alignment(0, -0.45),
                        child: Text(
                          'or',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.6, -0.4),
                        child: Container(
                          height: 2,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.6, -0.4),
                        child: Container(
                          height: 2,
                          width: 100,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.3, 0.25),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: RawMaterialButton(
                              shape: CircleBorder(),
                              child: Image.asset(
                                'assets/icons/google.png',
                                height: 30,
                                width: 30,
                              ),
                              onPressed: () {
                                validateWithGoogle();
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.3, 0.25),
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: RawMaterialButton(
                                shape: CircleBorder(),
                                child: Image.asset(
                                  'assets/icons/facebook.png',
                                  height: 30,
                                  width: 30,
                                ),
                                onPressed: validateWithFacebook)),
                      )
                    ],
                  ),
                ),
              )
            : PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0)),
        _showCircularProgress()
      ],
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return PreferredSize(child: Container(), preferredSize: Size(0.0, 0.0));
  }

  Widget showNameInput() {
    if (_isLoginForm) {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Username',
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
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Confirm password',
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (val) {
            if (_passwordController.text != val) {
              return 'Password not match';
            }
            return null;
          },
          onSaved: (val) => _password = val.trim(),
        ),
      );
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 11.0,
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

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height / 2.5,
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.circular(20)),
          color: Colors.white),
    );
  }
}

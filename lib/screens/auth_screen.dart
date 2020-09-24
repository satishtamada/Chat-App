import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatefulWidget {
  static final String routeName = '/authscreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var username = "";
  var userEmail = "";
  var userPassword = "";
  bool isLogin = true;
  var auth = FirebaseAuth.instance;
  bool isLoaderShowing = false;

  bool validateEmail(String input) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    return emailValid;
  }

  void onRegisterLinkClicked() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void doRegister(BuildContext ctx) async {
    var isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      AuthResult authResult;
      try {
        if (isLogin) {
          authResult = await auth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword);
        } else {
          print(username);
          authResult = await auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
          await Firestore.instance
              .collection('users')
              .document(authResult.user.uid)
              .setData({'userName': username, 'userEmail': userEmail});
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print("error");
        print(e.toString());
      }
      print(userEmail);
      print(userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!isLogin)
                      TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(labelText: 'Name'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                    TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (!validateEmail(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userEmail = value;
                      },
                    ),
                    TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        doRegister(context);
                      },
                      color: Colors.blue,
                      child: Text(
                        isLogin ? 'Login' : 'register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        onRegisterLinkClicked();
                      },
                      child: Text(
                          isLogin ? 'Create new user' : 'Already register..!'),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_car_expense/main.dart';
//import 'package:marquee/marquee.dart';

import 'dart:io';

import 'package:my_car_expense/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;
  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool loginfail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      checkInternet();
    });
  }

  Future<bool> onBackPressed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Quit?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "No",
                      style: TextStyle(fontSize: 16.0),
                    )),
                FlatButton(
                    // onPressed: () => Navigator.pop(context, true),
                    onPressed: () => exit(0),
                    child: Text(
                      "Quit",
                      style: TextStyle(fontSize: 16.0),
                    ))
              ],
            ));
  }

  Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Instruction'),
                content: Text('Please Turn On Internet'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Login'),
          // ),
          body: Container(
              //color: new Color(0xFF3FC1C9),
              //color: Colors.deepPurple[200],
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill),
              ),
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(height: 20.0),
                    //ExpenseImageAssets(),
                    Container(
                      height: 20.0,
                    ),
                    Center(
                        child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.deepPurple[900],
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Email',

                            // labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Your Registered Email ID';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            // labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onChanged: (value) {
                          setState(() {
                            _password = value.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0, right: 45.0),
                      child: RaisedButton(
                          color: Colors.deepPurple[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.orange)),
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            ' Log In',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          onPressed: () {
                            //login();

                            auth
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password)
                                .then((_) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => DrawerApp()));
                            }).catchError((e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Warning'),
                                  content: Text(
                                      'Enter Correct Email Id and Password'),
                                ),
                              );
                            });
                          }),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0, right: 45.0),
                      child: RaisedButton(
                          color: Colors.deepPurple[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.orange)),
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Create Account',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          onPressed: () {
                            //login();

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          }),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0, right: 45.0),
                      child: RaisedButton(
                          color: Colors.deepPurple[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.orange)),
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Reset Password',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await auth
                                  .sendPasswordResetEmail(email: _email)
                                  .then((_) {
                                if (_email != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Check'),
                                      content: Text(
                                          'Check $_email for password reset'),
                                    ),
                                  );
                                }
                              }).catchError((e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Warning'),
                                    content:
                                        Text('Please enter the correct email'),
                                  ),
                                );
                              });
                              emailController.text = '';
                            }
                            //login();
                          }),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Container(
                      height: 20.0,
                    ),
                    // Center(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'Developed by ',
                    //         style: TextStyle(color: Colors.deepPurple),
                    //       ),
                    //       Container(
                    //         height: 5.0,
                    //       ),
                    //       Text(
                    //         'Aniruddh Fataniya',
                    //         style: TextStyle(
                    //             color: Colors.deepPurple,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ))),
    );
  }
}

// class ExpenseImageAssets extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AssetImage assetImage = AssetImage('images/logo.png');
//     Image image = Image(image: assetImage, width: 150.0, height: 150.0);
//     return Center(
//         child: Container(padding: EdgeInsets.only(bottom: 20.0), child: image));
//   }
//}

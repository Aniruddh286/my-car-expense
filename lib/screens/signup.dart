import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_car_expense/main.dart';
import 'package:my_car_expense/screens/expense.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:marquee/marquee.dart';

import 'dart:io';

import 'package:my_car_expense/screens/login.dart';
import 'package:page_transition/page_transition.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email, _password;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
    //Navigator.pop(context);
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginScreen()));

    // return showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Do you want to exit?"),
    //           actions: <Widget>[
    //             FlatButton(
    //                 onPressed: () => Navigator.pop(context, false),
    //                 child: Text("No")),
    //             FlatButton(
    //                 // onPressed: () => Navigator.pop(context, true),
    //                 onPressed: () => exit(0),
    //                 child: Text("Yes"))
    //           ],
    //         ));
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

  void sendVerification() async {
    User user = auth.currentUser;
    await user.sendEmailVerification();
    Fluttertoast.showToast(
        msg: "Email Verification link has been sent to your email");
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
        //color: Colors.deepPurple[200],
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.jpg'), fit: BoxFit.fill),
        ),

        //color: Colors.teal,
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
                  'Create Account',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.deepPurple[800],
                      fontWeight: FontWeight.bold),
                )),
                Container(
                  height: 20.0,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: nameController,
                //     keyboardType: TextInputType.name,
                //     decoration: InputDecoration(
                //         filled: true,
                //         labelText: 'Name',
                //         // labelStyle: textStyle,
                //         border: OutlineInputBorder(
                //           borderSide:
                //               const BorderSide(color: Colors.white, width: 1.0),
                //           borderRadius: BorderRadius.circular(5.0),
                //         )),
                //     onChanged: (value) {
                //       setState(() {
                //         // _email = value.trim();
                //       });
                //     },
                //     validator: (String value) {
                //       if (value.isEmpty) {
                //         return 'Enter Your Name';
                //       }
                //     },
                //   ),
                // ),
                Container(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Email',

                        // labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Enter Email ID';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Enter Password';
                      }
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
                        'Create',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      onPressed: () {
                        //login();
                        // signup(_email, _password);
                        if (_formKey.currentState.validate()) {
                          auth
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password)
                              .then((_) {
                            sendVerification();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }).catchError((e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Error while creating account,Reason might be the Email id is already in use or password entered is less than six characters'),
                              ),
                            );
                            // if (e.runtimeType == 'weak-password') {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) => AlertDialog(
                            //       title: Text('Warning'),
                            //       content: Text('The Password provided is too weak'),
                            //     ),
                            //   );
                            // } else if (e.runtimeType == 'email-already-in-use') {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) => AlertDialog(
                            //       title: Text('Warning'),
                            //       content: Text(
                            //           'The account already exists for the provided email id'),
                            //     ),
                            //   );
                            // }
                          });
                        }
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
            )),
      )),
    );
  }

  // Future<String> signup(String email, String password) async {
  //   User user = (await auth.createUserWithEmailAndPassword(
  //       email: email, password: password))as User;
  //   try {
  //     await user.sendEmailVerification();
  //     return user.uid;
  //   } catch (e) {
  //     print("An error occured while trying to send email        verification");
  //     print(e.message);
  //   }
  // }
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

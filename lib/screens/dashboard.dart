import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_car_expense/main.dart';
import 'package:my_car_expense/screens/login.dart';
import 'package:my_car_expense/services/authentication_service.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> with ChangeNotifier {
  double totalDatewiseIncome = 0.0;
  double totalDatewiseBalance = 0.0;
  double totalDatewiseExpense = 0.0;
  @override
  void initState() {
    super.initState();
    checkInternet();
    getDatewiseIncome();
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
                title: Text('Warning'),
                content: Text('Please Turn On Internet'),
              ));
    }
  }

  Future getDatewiseIncome() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser?.uid;
    DateTime date = DateTime.now();

    var temp = await _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .where('expenseType', isEqualTo: 'Income')
        .where('expenseDate',
            isGreaterThanOrEqualTo: new DateTime(date.year, date.month, 1))
        .get();

    temp.docs
        .forEach((doc) => totalDatewiseIncome += doc.data()['expenseAmount']);
    print('DateWise Income:$totalDatewiseIncome');
    //return totalDatewiseIncome;

    var temp1 = await _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .where('expenseType', isEqualTo: 'Expense')
        .where('expenseDate',
            isGreaterThanOrEqualTo: new DateTime(date.year, date.month, 1))
        .get();

    temp1.docs
        .forEach((doc) => totalDatewiseExpense += doc.data()['expenseAmount']);

    print('TotalExpense:$totalDatewiseExpense');
    //return totalDatewiseIncome;
    setState(() {
      totalDatewiseBalance = totalDatewiseIncome - totalDatewiseExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: DrawerCodeOnly(),
        appBar: AppBar(title: Text('Dashboard'), actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut();
              // await auth.signOut().then((value) {
              //   print('hi.....................');
              //context.read<AuthenticationService>().notifyListeners();

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
              print('Sign out successfully');
            },
          )
        ]),
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: Container(
              // color: Colors.deepPurple[50],
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill),
              ),
              child: ListView(children: [
                Column(
                  children: [
                    Container(
                      //padding: EdgeInsets.all(10.0),
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/car.gif'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.orange)
                            ),
                            elevation: 10.0,
                            color: Colors.deepPurple[400],
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'THIS MONTH',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.orange)
                            ),
                            elevation: 10.0,
                            color: Colors.teal[400],
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'INCOME',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${totalDatewiseIncome.toString()}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.orange)
                            ),
                            elevation: 10.0,
                            color: Colors.red[400],
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'EXPENSE',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${totalDatewiseExpense.toString()}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.orange)
                            ),
                            elevation: 10.0,
                            color: Colors.blue[400],
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'BALANCE',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${totalDatewiseBalance.toString()}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment(0.5, 1),
                  child: FacebookBannerAd(
                    placementId: Platform.isAndroid
                        ? "969828426881257_969843656879734"
                        : "YOUR_IOS_PLACEMENT_ID",
                    bannerSize: BannerSize.STANDARD,
                    listener: (result, value) {
                      switch (result) {
                        case BannerAdResult.ERROR:
                          print("Error: $value");
                          break;
                        case BannerAdResult.LOADED:
                          print("Loaded: $value");
                          break;
                        case BannerAdResult.CLICKED:
                          print("Clicked: $value");
                          break;
                        case BannerAdResult.LOGGING_IMPRESSION:
                          print("Logging Impression: $value");
                          break;
                      }
                    },
                  ),
                )
              ])),
        ));
  }

  Future<LoginScreen> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return new LoginScreen();
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
}

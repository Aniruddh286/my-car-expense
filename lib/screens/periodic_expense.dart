import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_car_expense/main.dart';
import 'package:my_car_expense/models/expense_model.dart';
import 'package:my_car_expense/providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PeriodicExpense extends StatefulWidget {
  final ExpenseModel expenseModel;
  PeriodicExpense({this.expenseModel});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PeriodicExpenseState();
  }
}

class PeriodicExpenseState extends State<PeriodicExpense> {
  DateTime startDate;
  DateTime endDate;
  double totalDatewiseIncome = 0.0;
  double totalDatewiseBalance = 0.0;
  double totalDatewiseExpense = 0.0;
  bool viewVisible = false;
  TextEditingController incomeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomeController = new TextEditingController();

    setState(() {
      startDate = DateTime.now();

      endDate = DateTime.now().add(new Duration(days: 2));
      getDatewiseIncome();
    });
  }

  void showText() {
    setState(() {
      viewVisible = true;
    });
  }

  Future getDatewiseIncome() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser?.uid;

    var temp = await _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .where('expenseType', isEqualTo: 'Income')
        .where('expenseDate', isGreaterThanOrEqualTo: startDate)
        .where('expenseDate', isLessThanOrEqualTo: endDate)
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
        .where('expenseDate', isGreaterThanOrEqualTo: startDate)
        .where('expenseDate', isLessThanOrEqualTo: endDate)
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
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    // TODO: implement build
    return Scaffold(
        drawer: DrawerCodeOnly(),
        appBar: AppBar(
          title: Text('Periodic Expense/Income'),
          //actions: <Widget>[
          //   Padding(
          //       padding: EdgeInsets.only(right: 20.0),
          //       child: GestureDetector(
          //         onTap: () {
          //           print('Touched pdf icon');
          //           // generatepdf();
          //           writeOnPdf();
          //         },
          //         child: Icon(
          //           Icons.picture_as_pdf,
          //           size: 26.0,
          //         ),
          //       )),
          // ]
        ),
        body: WillPopScope(
            onWillPop: onBackPressed,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                children: <Widget>[
                  Container(height: 20.0),
                  Center(
                    child: MaterialButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.orange)),
                      padding: EdgeInsets.all(15.0),
                      elevation: 10.0,
                      onPressed: () async {
                        totalDatewiseIncome = 0.0;
                        totalDatewiseBalance = 0.0;
                        totalDatewiseExpense = 0.0;
                        final List<DateTime> picked =
                            await DateRangePicker.showDatePicker(
                                context: context,
                                initialFirstDate: new DateTime.now(),
                                initialLastDate: (new DateTime.now())
                                    .add(new Duration(days: 2)),
                                firstDate: new DateTime(2015),
                                lastDate: new DateTime(2030));
                        if (picked != null && picked.length == 2) {
                          setState(() {
                            print(picked[0]);
                            print(picked[1]);
                            startDate = picked[0];
                            endDate = picked[1];
                            getDatewiseIncome();
                            showText();
                          });
                        }
                      },
                      child: Container(
                        width: 220.0,
                        child: Center(
                          child: Row(children: <Widget>[
                            Icon(Icons.calendar_today),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              'SELECT DATE RANGE',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ]),
                        ),
                      ),

                      // child: new Text(
                      //   "Select Date Range",
                      //   style: TextStyle(fontSize: 18.0),
                      // )
                    ),
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: viewVisible,
                      child: Container(
                          child: Column(children: [
                        Text(
                          'START DATE: ${startDateConverted().toString()}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 10.0,
                        ),
                        Text(
                          'END DATE: ${endDateConverted().toString()}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 10.0,
                        ),
                      ]))),

                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Card(
                      elevation: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'CALCULATION',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            ),
                            Container(
                              height: 10.0,
                            ),
                            Text('INCOME: ${totalDatewiseIncome.toString()}',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                )),
                            Container(
                              height: 10.0,
                            ),
                            Text('EXPENSE: ${totalDatewiseExpense.toString()}',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                )),
                            Container(
                              height: 10.0,
                            ),
                            Text('BALANCE: ${totalDatewiseBalance.toString()}',
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 10.0,
                  ),
                  Container(
                    alignment: Alignment(0.5, 1),
                    child: FacebookBannerAd(
                      placementId: Platform.isAndroid
                          ? "498797501136699_498797664470016"
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
                  // Row(
                  //   children: <Widget>[
                  //     Text('Income: ₹ ',
                  //         // textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           color: Colors.teal,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17.0,
                  //         )),
                  //     Text(totalIncome.toString(),
                  //         // textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.teal,
                  //           fontSize: 17.0,
                  //         )),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 2.0,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Text('Expense: ₹ ',
                  //         // textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.red[400],
                  //           fontSize: 17.0,
                  //         )),
                  //     Text(totalExpense.toString(),
                  //         //textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           color: Colors.red[400],
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17.0,
                  //         )),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 2.0,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Text('Balance: ₹ ',
                  //         // textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           color: Colors.blue[800],
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17.0,
                  //         )),
                  //     Text((totalIncome - totalExpense).toString(),
                  //         // textDirection: TextDirection.ltr,
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.blue[800],
                  //           fontSize: 17.0,
                  //         )),
                  //   ],
                  // )
                ],
              ),
            )));
  }

  startDateConverted() {
    String sd = new DateFormat("dd-MM-yyyy").format(startDate);
    return sd;
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

  endDateConverted() {
    String sd = new DateFormat("dd-MM-yyyy").format(endDate);
    return sd;
  }
}

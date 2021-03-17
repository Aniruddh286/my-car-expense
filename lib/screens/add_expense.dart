import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:my_car_expense/models/expense_model.dart';
import 'package:my_car_expense/screens/login.dart';
import 'package:my_car_expense/services/authentication_service.dart';

import '../main.dart';
import '../providers/expense_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'expense.dart';

class AddExpense extends StatefulWidget {
  final ExpenseModel expenseModel;
  AddExpense([this.expenseModel]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddExpenseState();
  }
}

class AddExpenseState extends State<AddExpense> with ChangeNotifier {
  static var _expenseType = [
    'Select Type',
    'Expense',
    'Income',
  ];
  var _currentExpenseSelected = '';
  var _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  ExpenseModel expenseModel;

  Future<void> _selectDate(BuildContext context) async {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //  expenseProvider.changeExpenseDate(selectedDate);

        // String convertedDate = new DateFormat("dd-MM-yyyy").format(picked);
        //dateController.value = TextEditingValue(text: picked.toString());
        //dateController.value = TextEditingValue(text: convertedDate);
        //expenseProvider.changeExpenseDate(convertedDate);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.expenseModel == null) {
      dateController.text = "";
      amountController.text = "";
      descriptionController.text = "";
      new Future.delayed(Duration.zero, () {
        final expenseProvider =
            Provider.of<ExpenseProvider>(context, listen: false);
        expenseProvider.loadValues(ExpenseModel());
      });
    } else {
      //Controller update
      //dateController.text = widget.expenseModel.expenseDate;
      amountController.text = widget.expenseModel.expenseAmount.toString();
      print(amountController.text);
      descriptionController.text = widget.expenseModel.expenseDescription;
      print(descriptionController.text);
      //  _currentExpenseSelected = widget.expenseModel.expenseType;
      //State Update
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.loadValues(widget.expenseModel);
      new Future.delayed(Duration.zero, () {});
    }
    super.initState();
    _currentExpenseSelected = _expenseType[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Add Expense/Income'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await context.read<AuthenticationService>().signOut();
                    context.read<AuthenticationService>().notifyListeners();
                    //FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  },
                )
              ],
            ),
            drawer: DrawerCodeOnly(),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill),
              ),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListView(
                      children: <Widget>[
                        ExpenseImageAssets(),
                        //First Element

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(6.0),
                          //   border:
                          //   Border.all(
                          //       color: Colors.grey,
                          //       style: BorderStyle.solid,
                          //       width: 0.80),

                          // ),

                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: DropdownButtonFormField(
                              // underline: Text(''),
                              isExpanded: true,

                              items:
                                  _expenseType.map((String dropDownStringItem) {
                                return DropdownMenuItem(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(
                                          color: Colors.deepPurple[700]),
                                    ));
                              }).toList(),

                              //style: textStyle,
                              value: //getExpenseAsString(expenseModel.expenseType),
                                  _currentExpenseSelected,
                              validator: (value) {
                                if (value == _expenseType[0]) {
                                  return 'Select Type';
                                }
                              },

                              onChanged: (valueSelectedByUser) {
                                setState(
                                  () {
                                    debugPrint(
                                        'User selected value $valueSelectedByUser');
                                    _currentExpenseSelected =
                                        valueSelectedByUser;

                                    expenseProvider.changeExpenseType(
                                        _currentExpenseSelected);
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        //Second element
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            // style: textStyle,
                            onChanged: (value) {
                              debugPrint(
                                  'Something Changed in amount text Field');
                              expenseProvider.changeExpenseAmount(value);
                              //updateTitle();
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter Amount';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Amount',
                                // labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        //Third element
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: TextFormField(
                            controller: descriptionController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              debugPrint(
                                  'Something Changed in Description text Field');
                              expenseProvider.changeExpenseDescription(value);
                              //updateDescription();
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter Description';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Description',
                                // labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      // color: Colors.deepPurple[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side:
                                              BorderSide(color: Colors.orange)),
                                      padding: EdgeInsets.all(15.0),
                                      elevation: 10.0,
                                      child: Text(
                                        'SAVE',
                                        textScaleFactor: 1.2,
                                      ),
                                      onPressed: () {
                                        //debugPrint('Save Button Clicked');
                                        setState(() {
                                          if (_formKey.currentState
                                              .validate()) {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        Expense()));
                                            expenseProvider.saveExpense();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Detail Added Successfully');
                                            // _showAlertDialog('Status',
                                            //     'Detail Added Successfully');
                                          }
                                        });
                                      })),
                              Container(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      // color: Colors.red[400],
                                      //color: Colors.deepPurple[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side:
                                              BorderSide(color: Colors.orange)),
                                      padding: EdgeInsets.all(15.0),
                                      textColor: Colors.white,
                                      elevation: 10.0,
                                      child: Text(
                                        'CANCEL',
                                        textScaleFactor: 1.2,
                                      ),
                                      onPressed: () {
                                        debugPrint('Delete Button Clicked');
                                        Navigator.pop(context);
                                        // expenseProvider.removeExpense(
                                        //     widget.expenseModel.expenseId);
                                        // moveToLastScreen();
                                      }))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            )));
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

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

class ExpenseImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/car_ic.png');
    Image image = Image(image: assetImage, width: 150.0, height: 150.0);
    return Center(
        child: Container(padding: EdgeInsets.only(bottom: 20.0), child: image));
  }
}

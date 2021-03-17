import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:my_car_expense/models/expense_model.dart';
import 'package:my_car_expense/providers/expense_provider.dart';
import 'package:my_car_expense/services/authentication_service.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../main.dart';
import 'add_expense.dart';
import 'login.dart';

//import 'add_expense.dart';

class Expense extends StatefulWidget {
  final ExpenseModel expenseModel;
  Expense({this.expenseModel});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExpenseList();
  }
}

class ExpenseList extends State<Expense> with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  final auth = FirebaseAuth.instance;

  // ExpenseModel expenseModel;
  // HomeState homestate = HomeState();
  @override
  void initState() {
    // TODO: implement initState
    //{
    //Controller update

    super.initState();
    checkInternet();
    //   new Future.delayed(Duration.zero, () {

    //   });
    // }
    new Future.delayed(Duration.zero, () {
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.loadValues(widget.expenseModel);
    });
    print('${widget.expenseModel}');

    getIncome();
    getExpense();

    //getBalance();

    // searchController.addListener(_onSearchChanged);
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

  // _onSearchChanged() {
  //   print(searchController.text);
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   searchController.removeListener(_onSearchChanged());
  //   searchController.dispose();
  //   super.dispose();
  // }
  double totalIncome = 0.0;
  double totalBalance = 0.0;
  getIncome() async {
    var expenseProvider = ExpenseProvider();

    totalIncome = await expenseProvider.getTotalIncome();
    setState(() {
      print('Income:$totalIncome');
    });
  }

  double totalExpense = 0.0;
  getExpense() async {
    var expenseProvider = ExpenseProvider();

    totalExpense = await expenseProvider.getTotalExpense();
    setState(() {
      print('Expense:$totalExpense');
    });
  }

  getBalance() {
    totalBalance = totalIncome - totalExpense;
  }

  // double totalBalance = 0.0;
  // getBalance() {
  // totalBalance = totalIncome - totalExpense;
  // }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // int totalIncome = 0;

    // setState(() {
    //   debugPrint('Income:$totalIncome');
    // });

    return Scaffold(
        drawer: DrawerCodeOnly(),
        appBar: AppBar(title: Text('Expense/Income Detail'), actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut();
              // await auth.signOut().then((value) {
              //   print('hi.....................');
              context.read<AuthenticationService>().notifyListeners();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
              print('Sign out successfully');
              // }).catchError((onError) {
              //   print('${onError.toString()}');
              // });
              // await context.read<AuthenticationService>().signOut();
              // context.read<AuthenticationService>().notifyListeners();
              // //FirebaseAuth.instance.signOut();
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
            },
          )
        ]),
        body: WillPopScope(
            onWillPop: onBackPressed,
            child: Container(
              //color: Colors.deepPurple[50],
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill),
              ),

              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(
                            left: 5.0, right: 2.5, top: 5.0, bottom: 5.0),
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
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '${totalIncome.toString()}',
                                style: TextStyle(
                                    fontSize: 18.0,
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
                        padding: EdgeInsets.only(
                            left: 2.5, right: 2.5, top: 5.0, bottom: 5.0),
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
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '${totalExpense.toString()}',
                                style: TextStyle(
                                    fontSize: 18.0,
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
                        padding: EdgeInsets.only(
                            left: 2.5, right: 5.0, top: 5.0, bottom: 5.0),
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
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '${(totalIncome - totalExpense).toString()}',
                                style: TextStyle(
                                    fontSize: 18.0,
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
                  (expenses != null)
                      ?
                      // Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: SizedBox(
                      //         height: 500.0,
                      //         child:
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return FocusedMenuHolder(
                                    onPressed: () {},
                                    menuItems: <FocusedMenuItem>[
                                      FocusedMenuItem(
                                          title: Text(
                                            'Update',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddExpense(
                                                            expenses[index])));
                                          }),
                                      FocusedMenuItem(
                                          title: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[400]),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              getExpense();
                                              getIncome();
                                              getBalance();
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            "Do you want to Delete this item?"),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      false),
                                                              child: Text(
                                                                "No",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              )),
                                                          FlatButton(
                                                              // onPressed: () => Navigator.pop(context, true),
                                                              onPressed: () {
                                                                expenseProvider
                                                                    .removeExpense(
                                                                        expenses[index]
                                                                            .expenseId);
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'Item Deleted Successfully');
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ))
                                                        ],
                                                      ));

                                              // _showSnackBar(context,
                                              //     'Item Deleted Successfully');
                                              // _delete(index);
                                            });

                                            // expenseProvider.removeExpense(
                                            //     widget.expenseModel.expenseId);
                                          }),
                                    ],
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          top: 2.5,
                                          bottom: 2.5),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                                color: Colors.deepPurple[100])),
                                        elevation: 4.0,
                                        child: ListTile(
                                          title: Text(
                                            expenses[index].expenseDescription,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(_date(index)),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                getExpenseTypeColor(
                                                    expenses[index]
                                                        .expenseType),
                                            child: getExpenseTypeIcon(
                                                expenses[index].expenseType),
                                          ),
                                          trailing: Text(
                                            expenses[index]
                                                .expenseAmount
                                                .toString(),
                                            style: TextStyle(
                                                color: getExpenseTypeColor(
                                                    expenses[index]
                                                        .expenseType),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0),
                                          ),
                                          onTap: () {
                                            //homestate.getDrawerItemWidget(1);

                                            //     builder: (context) => AddExpense()));
                                          },
                                        ),
                                        //  Divider()
                                      ),
                                    ));
                              }))
                      : Center(child: RefreshProgressIndicator()),
                  Container(
                    alignment: Alignment(0.5, 1),
                    child: FacebookBannerAd(
                      placementId: Platform.isAndroid
                          ? "168477398331243_168477438331239"
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
                  ),
                ],
              ),
            )));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _date(i) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    //DateTime date = DateTime.parse(expenses[i].expenseDate.toDate().toString());
    // var date = new DateTime.fromMicrosecondsSinceEpoch(expenses[i].expenseDate);
    //print('Date:${expenses[i].expenseDate.toDate()}');
    //return date.toString();
    Timestamp timestamp = expenses[i].expenseDate;
    String convertedDate =
        new DateFormat("dd-MM-yyyy").format(timestamp.toDate());
    //print(timestamp.toDate().toString());
    return convertedDate;
  }

  //Reurns Priority Color
  Color getExpenseTypeColor(String expenseType) {
    switch (expenseType) {
      case 'Income':
        return Colors.teal;
        break;
      case 'Expense':
        return Colors.red[400];
        break;
      default:
        return Colors.teal;
    }
  }

  Icon getExpenseTypeIcon(String expenseType) {
    switch (expenseType) {
      case 'Income':
        return Icon(Icons.add);
        break;
      case 'Expense':
        return Icon(Icons.remove);
        break;
      default:
        return Icon(Icons.add);
    }
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

  Future<bool> _delete(int index) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      expenseProvider.removeExpense(expenses[index].expenseId);
                    },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("No"))
              ],
            ));
  }

  Future<LoginScreen> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return new LoginScreen();
  }
}

// class ExpesneTexts extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final expenseProvider = Provider.of<ExpenseProvider>(context);
//     int totalIncome = 0;
//     totalIncome = expenseProvider.getTotalIncome();

//     return Container(
//         padding: EdgeInsets.all(5.0),
//         child: Card(
//             elevation: 10.0,
//             color: Colors.indigo[50],
//             child: Container(
//               padding: EdgeInsets.all(5.0),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Text('આવક: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontSize: 20.0,
//                           )),
//                       Text(totalIncome.toString(),
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text('જાવક: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: 20.0,
//                           )),
//                       Text(' ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text('જમા રકમ: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 20.0,
//                           )),
//                       Text(' ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   )
//                 ],
//               ),
//             )));
//   }
// }

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Hi')),
    );
  }
}

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_car_expense/providers/expense_provider.dart';
import 'package:my_car_expense/screens/add_expense.dart';
import 'package:my_car_expense/screens/dashboard.dart';
import 'package:my_car_expense/screens/expense.dart';
import 'package:my_car_expense/screens/login.dart';
import 'package:my_car_expense/screens/periodic_expense.dart';
import 'package:my_car_expense/screens/splash_screen.dart';
import 'package:my_car_expense/services/authentication_service.dart';
import 'package:my_car_expense/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:my_society/authenticate/register.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'models/expense_model.dart';

//import 'package:my_society/authenticate/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FacebookAudienceNetwork.init(
      //testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6",
      );

  // final firestoreService = FireStoreService();

  // var materialApp = MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => ExpenseProvider()),
  //       StreamProvider(create: (context) => firestoreService.getExpense()),
  //     ],
  //     child: MaterialApp(
  //       title: "Society Management",
  //       debugShowCheckedModeBanner: false,
  //       home: Expense(),
  //       theme: ThemeData(
  //           brightness: Brightness.light,
  //           primaryColor: Colors.indigo[900],
  //           accentColor: Colors.indigoAccent,
  //           primaryColorDark: Colors.indigo[700]),
  //     ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final firestoreService = FireStoreService();
    //final report = ReportState();
    //report.startDate = DateTime.now();
    //report.endDate = DateTime.now();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        StreamProvider(create: (context) => firestoreService.getExpense()),
        // StreamProvider(
        //     create: (context) => firestoreService.getDateWiseExpense(
        //         report.startDate, report.endDate)),

        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'My Car Expense',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            primaryColorDark: Colors.deepPurple[900]),
        home: Splash(),
      ),
    );
  }
}

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: DrawerCodeOnly(),
        //appBar: AppBar(title: Text("શ્રી હરિ બંગ્લોઝ")),
        body: Dashboard()
        // Expense(
        //   expenseModel: ExpenseModel(
        //       expenseAmount: 0.0,
        //       //expenseDate: '1/1/2020',
        //       expenseDescription: '',
        //       expenseId: '',
        //       expenseType: ''),
        //)
        );
  }
}

class DrawerCodeOnly extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  String email = FirebaseAuth.instance.currentUser?.email;
  _launchURL() async {
    const url =
        'https://sites.google.com/view/my-car-expense-privacy-policy/home';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text('My Car Expense',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold)),
                    Text('$email',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/car.gif'), fit: BoxFit.fill),
            ),
          ),
          ListTile(
            title: Text(
              'Dashboard',
              style: TextStyle(
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            leading: Icon(Icons.dashboard, color: Colors.deepOrange[400]),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Dashboard()));
            },
          ),
          ListTile(
            title: Text(
              'Expense/Income',
              style: TextStyle(
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            leading: Icon(Icons.monetization_on_rounded,
                color: Colors.deepOrange[400]),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: Expense()));
            },
          ),
          ListTile(
            title: Text('Add Expense/Income',
                style: TextStyle(
                    color: Colors.deepPurple[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.add_box_rounded, color: Colors.deepOrange[400]),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AddExpense()));
            },
          ),
          ListTile(
            title: Text('Periodic Expense/Income',
                style: TextStyle(
                    color: Colors.deepPurple[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.people, color: Colors.deepOrange[400]),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: PeriodicExpense()));
            },
          ),
          Divider(),
          ListTile(
              title: Text('Privacy Policy',
                  style: TextStyle(
                      color: Colors.deepPurple[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0)),
              leading: Icon(
                Icons.policy_rounded,
                color: Colors.deepOrange[400],
              ),
              onTap: () {
                _launchURL();
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             type: PageTransitionType.rightToLeft,
                //             child: LoginScreen()));
                //   },
                // ),
              }),
          // Divider(),
          // Container(
          //   height: 20.0,
          // ),
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
          //             color: Colors.deepPurple, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // )
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Expanded(
          //       child: Container(
          //     alignment: Alignment.bottomCenter,
          //     padding: EdgeInsets.only(top: 50.0, left: 20.0),
          //     height: 200,
          //     //color: Colors.teal,
          //     child: Marquee(
          //       text: '😊 Developed By Aniruddh Fataniya 😊',
          //       blankSpace: 120.0,
          //       startPadding: 5.0,
          //       //pauseAfterRound: Duration(seconds: 1),
          //       //accelerationDuration: Duration(seconds: 1),
          //       decelerationCurve: Curves.easeOut,
          //       style: TextStyle(color: Colors.orange),
          //     ),
          //   )),
          // )
        ],
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('${FirebaseAuth.instance.currentUser}');
    //   final firebaseUser = context.watch<User>();
    //   //userId(firebaseUser?.uid??"no user")
    //   final firebaseUser1 = context.watch<AuthenticationService>();
    //   if (firebaseUser != null) {
    //     return Expense();
    //   }
    //   return LoginScreen();

    return StreamBuilder<User>(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoginScreen();
        } else {
          //context.read<>()
          context.read<ExpenseProvider>().firestoreService = FireStoreService();

          return Dashboard();
        }
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}

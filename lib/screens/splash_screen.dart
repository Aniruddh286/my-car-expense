import 'dart:async';
//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:page_transition/page_transition.dart';

import '../main.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  //GifController controller = GifController(vsync: this);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigator.push(context, _createRoute());
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: Authenticate()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => Authenticate())));
    // TODO: implement build
    return Scaffold(
        body: Container(
      color: Colors.deepPurple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //GifImage(image: AssetImage("images/car.gif"), controller: controller),

          // fetchGif();
          Image.asset(
            'images/car.gif',
            height: 160.0,
            width: 250.0,
          ),
          SizedBox(height: 30.0),
          Text(
            'My Car Expense',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 30.0),
          //SpinKitRipple(color: Colors.white),
          SpinKitSquareCircle(
            color: Colors.deepPurple[100],
          )
        ],
      ),
    ));
  }
}

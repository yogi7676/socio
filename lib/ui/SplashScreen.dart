import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socio/ui/NavScreens/HomePage.dart';
import 'package:socio/ui/Login.dart';
import 'package:socio/resources/Repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var repository=Repository();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    getCurrentUser();
  }

  getCurrentUser() async{
    var user=await repository.getCurrentUser();
    if(user==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          CircleAvatar(radius: 70.0,child: Text("Socio",style: TextStyle(fontSize: 50.0,color: Colors.white),),),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("from",style: TextStyle(fontSize: 16.0,color: Colors.grey),),
                ),
                Text("India",style: TextStyle(fontSize: 18.0,color: Colors.grey),)
              ],
            ),
          )
        ],
      ),
    );
  }

}

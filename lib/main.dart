import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socio/ui/NavScreens/HomePage.dart';
import 'package:socio/ui/Register.dart';
import 'package:socio/ui/SplashScreen.dart';


void main(){

  var routes={
    '/register': (BuildContext context)=>Register(),
    '/homePage':(BuildContext context)=>HomePage(),
  };

  runApp(
      new MaterialApp(
        routes: routes,
        debugShowCheckedModeBanner: false,
        title: 'Socio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white,fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.black)),
          primaryIconTheme: IconThemeData(color: Colors.white),
        ),
        home: SplashScreen(),
  ));
}

Color mainColor = Color.fromRGBO(48, 96, 96, 1.0);
Color startingColor = Color.fromRGBO(70, 112, 112, 1.0);

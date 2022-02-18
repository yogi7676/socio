import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  getReceivedRequests() async{
    var user=await FirebaseAuth.instance.currentUser();
    var result=await Firestore.instance.collection("Users").document(user.uid).collection("Followers").getDocuments();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("ABCD")
        ],
      ),
    );
  }
}


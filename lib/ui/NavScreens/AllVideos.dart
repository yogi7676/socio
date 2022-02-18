import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllVideos extends StatefulWidget {
  @override
  _AllVideosState createState() => _AllVideosState();
}

class _AllVideosState extends State<AllVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
          "Pages",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic),
        ),
      ),*/
      body: Text("All Videos"),
    );
  }
}

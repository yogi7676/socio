import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';

class EmojiClass extends StatefulWidget {
  @override
  _EmojiClassState createState() => _EmojiClassState();
}

class _EmojiClassState extends State<EmojiClass> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    List<Color> color=[
      Colors.lime,
      Colors.blue,
      Colors.grey,
      Colors.teal,
    ];
    List<Widget> myRow=[];
    List<int> columns=[];
    List<List<int>> numbers=[];

    int z=0;
    for(int i=0;i<=9;i++){
      for(int j=0;j<=10;j++){
        int cur=z+j;
        columns.add(cur);
      }
      z+=10;
      numbers.add(columns);
      columns=[];
    }

    myRow=numbers.map((col){
      Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: col.map((nr){
         int min=0;
         int max=color.length;
         return Container(
           child: Text('${nr.toString()}'),
         );
       }).toList(),
      );
    }).toList();
    return Scaffold(
      body: color.length != 0
        ? Row(
        children:myRow
      ) : Container(),
    );
  }
}

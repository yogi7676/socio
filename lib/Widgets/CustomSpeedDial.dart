import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomSpeedDial extends StatelessWidget {

  final List<SpeedDialChild> speedDialChild;
  final AnimatedIconData animatedIcon;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconThemeData animatedIconTheme;
  final Color overlayColor;

  const CustomSpeedDial({Key key, this.speedDialChild, this.animatedIcon, this.backgroundColor, this.foregroundColor, this.animatedIconTheme, this.overlayColor,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: animatedIcon,
      animatedIconTheme: animatedIconTheme,
      overlayColor: overlayColor,
      visible: true,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      children: speedDialChild,
      shape: CircleBorder(),
    );
  }
}



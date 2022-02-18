import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatefulWidget {

  final Function onTap;
  final Widget image;
  final double biggerSize;
  final double smallSize;
  final IconData iconInSmallCircle;
  final Color color;
  final Color smallIconColor;
  const CustomCircleAvatar({Key key, this.onTap, this.image, this.biggerSize, this.smallSize, this.iconInSmallCircle, this.color, this.smallIconColor}) : super(key: key);

  @override
  _CustomCircleAvatarState createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>widget.onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          CircleAvatar(
              radius: widget.biggerSize,
              backgroundColor: widget.color,
              child: ClipOval(
                child: SizedBox(
                    height: 150.0,
                    width: 150.0,
                    child: widget.image),
              )
          ),
          CircleAvatar(
            radius: widget.smallSize,
            backgroundColor: widget.color,
            child: Icon(widget.iconInSmallCircle,size: 14.0,color: widget.smallIconColor,),
          )
        ],
      ),
    );
  }
}

import "package:flutter/material.dart";

class CustomDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BackgroundClipper(),
            child: Hero(
                tag: 'background',
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.8 *1.33,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Colors.blueGrey,
                        ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft
                    )
                  ),
                )),
          ),
        )
      ],
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 25.0;
    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, 0, size.height);
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height);
    path.lineTo(size.width, roundnessFactor * 2);
    path.quadraticBezierTo(size.width -10, roundnessFactor,
        size.width - roundnessFactor * 1.5, roundnessFactor * 1.5);
    path.lineTo(
        roundnessFactor * 0.6, size.height * 0.33 - roundnessFactor * 0.3);
    path.quadraticBezierTo(
        0, size.height * 0.33, 0, size.height * 0.33 + roundnessFactor);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

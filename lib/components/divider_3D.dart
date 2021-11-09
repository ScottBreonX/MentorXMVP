import 'package:flutter/material.dart';

class Divider3D extends StatelessWidget {
  const Divider3D({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey,
            Colors.grey.shade200,
          ],
        ),
      ),
    );
  }
}

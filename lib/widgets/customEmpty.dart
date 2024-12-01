import 'package:flutter/material.dart';

class CustomEmpty extends StatelessWidget {
  final double height;
  final double width;
  const CustomEmpty({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Text(
          'Empty',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

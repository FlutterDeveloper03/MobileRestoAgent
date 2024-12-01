import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final double height;
  final double width;
  const CustomLoading({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

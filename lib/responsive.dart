import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget big;

  const Responsive({
    super.key,
    required this.mobile,
    required this.big,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return big;
        } else {
          return mobile;
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final Widget image;
  final Widget widget;
  final double? height;
  const InfoItem(
      {Key? key, required this.image, required this.widget, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 2.7 / 2,
              child: Container(
                child: Hero(
                  tag: image,
                  child: image,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 14.0,
                      spreadRadius: 8.0,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                height: height ?? 45,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

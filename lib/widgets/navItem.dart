import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String label;
  final DecorationImage image;
  final bool isActive;
  const NavItem({
    Key? key,
    required this.isActive,
    required this.label,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.secondary : null,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColorDark),
          image: image,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: isActive ? Colors.white54 : Colors.black45,
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

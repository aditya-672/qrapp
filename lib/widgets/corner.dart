import 'package:flutter/material.dart';

class CustomCorner extends StatelessWidget {
  const CustomCorner({
    super.key,
    required this.sides,
  });
  final List<String> sides;
  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.only(
      topLeft: sides.contains('topLeft')
          ? const Radius.circular(36)
          : Radius.zero,
      bottomLeft: sides.contains('bottomLeft')
          ? const Radius.circular(36)
          : Radius.zero,
      bottomRight: sides.contains('bottomRight')
          ? const Radius.circular(36)
          : Radius.zero,
      topRight: sides.contains('topRight')
          ? const Radius.circular(36)
          : Radius.zero,
    );

    var borderSide = Border(
      top: sides.contains('top')
          ? const BorderSide(color: Colors.blue, width: 4)
          : BorderSide.none,
      left: sides.contains('left')
          ? const BorderSide(color: Colors.blue, width: 4)
          : BorderSide.none,
      bottom: sides.contains('bottom')
          ? const BorderSide(color: Colors.blue, width: 4)
          : BorderSide.none,
      right: sides.contains('right')
          ? const BorderSide(color: Colors.blue, width: 4)
          : BorderSide.none,
    );
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: borderSide,
      ),
    );
  }
}

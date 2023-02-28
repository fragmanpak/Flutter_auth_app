import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Color? color;

  const CommonButton({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: color),
      child: Center(
          child: Text(
        text,
      )),
    );
  }
}

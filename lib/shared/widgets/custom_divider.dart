import 'package:flutter/material.dart';


class CustomDivider extends StatelessWidget {
  final String? text;
  final Color? color;
  final double thickness;

  const CustomDivider({Key? key, this.text, this.color, this.thickness = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return Divider(color: color ?? Colors.grey[300], thickness: thickness);
    }

    return Row(
      children: [
        Expanded(child: Divider(color: color ?? Colors.grey[300], thickness: thickness)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text!, style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(child: Divider(color: color ?? Colors.grey[300], thickness: thickness)),
      ],
    );
  }
}
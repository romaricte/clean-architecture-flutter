import 'package:flutter/material.dart';


class CustomChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomChip({
    Key? key,
    required this.label,
    this.icon,
    this.onDeleted,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null ? Icon(icon, size: 18, color: textColor) : null,
      label: Text(label, style: TextStyle(color: textColor)),
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 18) : null,
      onDeleted: onDeleted,
      backgroundColor: backgroundColor ?? Colors.grey[200],
    );
  }
}
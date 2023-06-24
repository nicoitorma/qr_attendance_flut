import 'package:flutter/material.dart';

abstract class CustomTile extends StatelessWidget {
  final dynamic data;

  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const CustomTile(
      {super.key,
      required this.data,
      required this.color,
      this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context);
}

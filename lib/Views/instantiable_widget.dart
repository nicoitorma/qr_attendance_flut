import 'package:flutter/material.dart';

Widget customCard({required IconData icon, required String title}) => Container(
    padding: const EdgeInsets.all(5),
    height: 130,
    width: 150,
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 80),
        Text(title,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))
      ],
    ));

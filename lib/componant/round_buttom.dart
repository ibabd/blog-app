// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
class RoundButtton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  RoundButtton({required this.title,required this.onPress});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialButton(
        color: Colors.deepOrange,
        minWidth: double.infinity,
        height: 50,
        child: Text(title,style: TextStyle(color: Colors.white),),
        onPressed: onPress,
      ),

    );
  }
}

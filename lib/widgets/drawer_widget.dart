import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawerWidget extends StatelessWidget{
  const DrawerWidget({super.key,required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
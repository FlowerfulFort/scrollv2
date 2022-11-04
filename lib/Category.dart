import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:scrollv2/Task.dart';
import 'package:from_css_color/from_css_color.dart';
// const widgetHeight = 30;
class Category extends StatelessWidget {
  final String title;
  final String color;
  // final double height=30;
  final List<Task> tasklist = <Task>[];
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  Category({required this.title, required this.color});
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      onDragStarted: () => dev.log('Drag Category: $title at ${DateTime.now()}'),
      childWhenDragging: Container(),
      feedback: Material(child: this),
      child: Container(
        color: fromCssColor(color),
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
        child: Center(
          child: Text(title, style: textStyle),
        ),
      ),
      // onLongPress: () => dev.log('Category Long Pressed: $title at ${DateTime.now()}'),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
class CategoryView extends StatefulWidget {
  final Function refreshCallBack;
  CategoryView({required this.refreshCallBack});

  @override
  CategoryViewState createState() => CategoryViewState();
}

class CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            //height:30,
            //width:200,
            //height:30,
            //child: Cartegory(title: 'cart1', color: Colors.lightBlueAccent)
            /*child: ListView(
              //shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Cartegory(title: 'Cart1', color: Colors.lightGreenAccent),
                Cartegory(title: 'Cart2', color: Colors.lightBlueAccent),
                Cartegory(title: 'Cart1', color: Colors.lightGreenAccent),
                Cartegory(title: 'Cart2', color: Colors.lightBlueAccent),
                Cartegory(title: 'Cart1', color: Colors.lightGreenAccent),
                Cartegory(title: 'Cart2', color: Colors.lightBlueAccent),
              ]
            )
             */
/*
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) =>
                Cartegory(title: 'Cart1', color: Colors.lightBlueAccent)
            )
 */
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Category(title: 'Cate1', color: Colors.lightGreenAccent),
                  Category(title: 'Cate2', color: Colors.lightBlueAccent.shade100),
                  Category(title: 'Category', color: Colors.lightGreenAccent),
                  Category(title: 'Category12', color: Colors.lightBlueAccent),
                  Category(title: 'Cate6534', color: Colors.lightGreenAccent),
                  Category(title: 'Cate19749', color: Colors.lightBlueAccent),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Container(    // Add Category button.
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: const Icon(Icons.add, size:30),
            ),
            onTap: () => dev.log('Add category button clicked at ${DateTime.now()}')
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final Color color;
  final double height=30;
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
        color: color,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
        child: Center(
          child: Text(title, style: textStyle),
        ),
      ),
      //onLongPress: () => dev.log('Category Long Pressed: $title at ${DateTime.now()}'),
    );
  }
}
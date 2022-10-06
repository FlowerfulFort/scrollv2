import 'package:flutter/material.dart';
import 'package:scrollv2/CategoryView.dart';

class CartegoryView extends StatefulWidget {
  final Function refreshCallBack;
  CartegoryView({required this.refreshCallBack});

  @override
  CartegoryViewState createState() => CartegoryViewState();
}

class CartegoryViewState extends State<CartegoryView> {
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
                  Cartegory(title: 'Cart1', color: Colors.lightGreenAccent),
                  Cartegory(title: 'Cart2', color: Colors.lightBlueAccent.shade100),
                  Cartegory(title: 'Cartegory', color: Colors.lightGreenAccent),
                  Cartegory(title: 'Cartegory12', color: Colors.lightBlueAccent),
                  Cartegory(title: 'Cart6534', color: Colors.lightGreenAccent),
                  Cartegory(title: 'Cart19749', color: Colors.lightBlueAccent),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: const Icon(Icons.add, size:30),
          )
        ],
      ),
    );
  }
}

class Cartegory extends StatelessWidget {
  final String title;
  final Color color;
  final double height=30;
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  Cartegory({required this.title, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      child: Center(
        child: Text(title, style: textStyle),
      )
    );
  }
}
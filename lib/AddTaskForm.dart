/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'package:flutter/material.dart';
import 'package:time/time.dart';
// import 'ICSEdit.dart';
import 'TaskScrollView.dart';
import 'CategoryView.dart';
import 'Category.dart';
import 'dart:developer' as dev;

class AddTaskForm extends StatefulWidget {
  @override
  AddTaskFormState createState() => AddTaskFormState();
}
class AddTaskFormState extends State<AddTaskForm> {
  TextStyle style = const TextStyle(
    color: Colors.white,
    fontSize: 35,
  );
  bool filtering = false;
  Category? filtered;
  final titleController = TextEditingController();

  /* test data.. */
  void getData() => {'title': 'test', 'time': 0.seconds.fromNow};
  void render() => setState(() {});
  @override
  Widget build(BuildContext context) {
    dev.log('Render: AddTaskForm');
    // ICSEdit a = ICSEdit();
    // a.localPath.then((path) {
    //   dev.log('ICSEdit: $path');
    // });
    return Column(
      children: <Widget>[
        CategoryView(refreshCallBack: render),
        Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
          color: Colors.deepOrangeAccent.shade200,
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목'
                )
              ),
              FloatingActionButton(
                child: Icon(Icons.print),
                onPressed: () {
                  dev.log(titleController.text);
                  titleController.clear();
                  // widget.refreshCallBack();
                }
              )
            ],
          ),
        ),
        Expanded(child: TaskScrollView(refreshCallBack: render, getData: getData)),
      ],
    );
  }
}

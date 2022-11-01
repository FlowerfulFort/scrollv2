/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class AddTaskForm extends StatefulWidget {
  final Function refreshCallBack;
  AddTaskForm({required this.refreshCallBack});
  @override
  AddTaskFormState createState() => AddTaskFormState();
}
class AddTaskFormState extends State<AddTaskForm> {
  TextStyle style = const TextStyle(
    color: Colors.white,
    fontSize: 35,
  );
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    dev.log('Render: AddTaskForm');

    return Container(
      color: Colors.deepOrangeAccent,
      // height: 250,
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
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
                widget.refreshCallBack();
              }
            )
          ],
        ),
      ),
    );
  }
}

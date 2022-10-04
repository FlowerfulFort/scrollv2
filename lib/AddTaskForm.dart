/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'package:flutter/material.dart';

class AddTaskForm extends StatefulWidget {
  @override
  AddTaskFormState createState() => AddTaskFormState();
}
class AddTaskFormState extends State<AddTaskForm> {
  TextStyle style = const TextStyle(
    color: Colors.white,
    fontSize: 35,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepOrangeAccent,
        height: 250,
        child: Center(child: Text('Add Task Form Here.', style: style))
    );
  }
}

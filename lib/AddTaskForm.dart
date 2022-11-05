/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'package:flutter/material.dart';
import 'package:time/time.dart';
// import 'ICSEdit.dart';
import 'package:scrollv2/TaskScrollView.dart';
import 'package:scrollv2/CategoryView.dart';
// import 'package:scrollv2/Category.dart';
import 'package:scrollv2/TestSet.dart';
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
  // bool filtering = false;
  // Category? filtered;
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
    return FutureBuilder(
      future: makeTest(20),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          dev.log('Error Occurred at FutureBuilder: ${snapshot.error}');
          return Center(child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ));
        }
        else {
          return Column(
            children: <Widget>[
              CategoryView(refreshCallBack: render, categoryList: snapshot.data.item1),
              Container(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                color: Colors.deepOrangeAccent.shade200,
                child: Column(
                  children: <Widget>[
                    TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '제목'
                        )
                    ),
                    FloatingActionButton(
                        child: const Icon(Icons.print),
                        onPressed: () {
                          dev.log(titleController.text);
                          titleController.clear();
                          render();
                          // widget.refreshCallBack();
                        }
                    )
                  ],
                ),
              ),
              Expanded(child: TaskScrollView(
                  refreshCallBack: render,
                  getData: getData,
                  taskList: snapshot.data.item2
              )),
            ],
          );
        }
      },
    );
  }
}

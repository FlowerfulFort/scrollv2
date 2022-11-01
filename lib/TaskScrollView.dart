/* Widget: TaskScrollView
 * 하단에 일정을 보여줄 스크롤뷰.
 * 무한 스크롤을 구현해야 한다.
 * 처음 실행할때 State를 현재 날짜로 하고
 * 특정한 지점으로 이동할때 State를 해당 날짜로 바꾸어 다시 렌더링 하면 될듯..
 */
import 'package:flutter/material.dart';
import 'package:scrollv2/Task.dart';
import 'dart:developer' as dev;

class TaskScrollView extends StatefulWidget {
  final Function refreshCallBack;
  final Function getData;
  TaskScrollView({required this.refreshCallBack, required this.getData});
  @override
  TaskScrollViewState createState() => TaskScrollViewState();
}

class TaskScrollViewState extends State<TaskScrollView> {
  TextStyle testStyle = const TextStyle(
    color: Colors.blueAccent,
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    dev.log('Render: TaskScrollView');

    return ListView(
      padding: EdgeInsets.zero,   // remove whitespace on top.
      children: makeTaskList(makeTestTask(20)),
    );
  }

  List<Widget> makeTaskList(List<Task> l) {
    return l.map((task) =>    // update code for viewing time required...
        Container(
          color: Colors.lightGreenAccent,
          child: Text(task.title, style: testStyle),
    )).toList();
  }
}
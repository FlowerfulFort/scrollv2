import 'package:time/time.dart';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
extension TimeParse on DateTime{
  String get clock => '$minute:$second';
}

class Task {
  Task(this.title, this.start, this.end, this.color, this.alarm);
  Task.na(this.title, this.start, this.end, this.color);
  String title;
  DateTime start;
  DateTime end;
  bool? alarm;
  String color;   // CSS3 Color keyword
  String get clock => '${start.minute}:${start.second}';
  @override
  String toString() => 'TestTask: $title time: $start ~ $end';
}


/* make test task list, size=n
List<Task> makeTestTask(int n) {

  var list = <Task>[];
  const String testTitle = 'Test title #';
  for (int i=0;i<n;i++) {
    DateTime start = (Random().nextInt(30) + 30).minutes.fromNow;
    DateTime end = start + (Random().nextInt(30) + 30).minutes;
    var t = Task.na(
      testTitle + TestTask.index.toString(),
      start,
      end,
      Colors.blue
    );
    TestTask.index++;
    list.add(t);
    dev.log('$t');
  }
  //var a = Task('123',DateTime.now(), DateTime.now(), false);
  // var list2 = <Task>[
  //   for (int i=0;i<n;i++) Task(
  //     testTitle + i.toString(),
  //     (Random().nextInt(3)+1).days.fromNow,
  //     Random().nextInt(24).hours + Random().nextInt(60).minutes,
  //     start + (Random().nextInt(30) + 30).minutes,
  //     false
  //   )
  // ];
  return list;
}
*/
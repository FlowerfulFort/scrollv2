// import 'package:time/time.dart';
// import 'dart:developer' as dev;
// import 'dart:math';
// import 'package:flutter/material.dart';
extension TimeParse on DateTime{
  String get clock => '$hour2:$minute2';
  String get time => '$month/$day $clock';
  String get hour2 => '${hour<10 ? '0$hour' : hour}';
  String get minute2 => '${minute<10 ? '0$minute' : minute}';
  String get serialize {
    var temp = toIso8601String();
    temp = temp.substring(0, temp.indexOf('.'));
    temp = temp.split(RegExp(r'[-:]')).join();
    if (isUtc) temp += 'Z';
    return temp;
  }
}

const VEVENT_HEADER = 'BEGIN:VEVENT';
const VEVENT_FOOTER = 'END:VEVENT';
class Task {
  static int sequence = 0;
  Task(this.title, this.start, this.end, this.color, this.alarm);
  Task.na(this.title, this.start, this.end, this.color);
  String title;
  DateTime start;
  DateTime end;
  bool? alarm;
  String color;   // CSS3 Color keyword
  String get clock => '${start.hour2}:${start.minute2}';
  String get time => '${start.month}/${start.day} $clock';
  String get vevent =>
      '$VEVENT_HEADER\n'
      'UID:${title.split(RegExp(r'[- /:.]')).join()}_${start.serialize}\n'
      'DTSTART:${start.serialize}\n'
      'DTEND:${end.serialize}\n'
      'CREATED:${DateTime.now().serialize}\n'
      'COLOR:$color\n'
      'LAST-MODIFIED:${DateTime.now().serialize}\n'
      'LOCATION:\n'
      'SEQUENCE:${Task.sequence++}\n'
      'SUMMARY:$title\n'
      '$VEVENT_FOOTER\n';
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
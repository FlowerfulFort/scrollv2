import 'dart:math';
import 'dart:developer' as dev;
import 'package:time/time.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:scrollv2/Task.dart';
import 'package:scrollv2/Category.dart';

typedef TestSet = Tuple2<List<Category>, List<Task>>;

extension BoolCasting on num {
  bool get toBool => this == 0 ? false : true;
}

const testColorSet = <Color>[
  Colors.lightBlueAccent,
  Colors.orangeAccent,
  Colors.lightGreen,
  Colors.deepPurpleAccent,
  Colors.grey,
  Colors.yellow
];

// fetch list from package 'from_css_color'.
final colorList = List<String>.from(colorKeywords.keys);
class TestTask{
  static int index = 0;   // 테스트일정 구분을 위한 static variable.
}
DateTime _generateTime() {
  final rand = Random(0.seconds.fromNow.microsecond);
  var day = rand.nextInt(6).days.fromNow - 3.days; // -3 ~ 3 day
  day += (rand.nextInt(24) - 12).hours;
  return day;
}

List<String> _extractColorList(int n) {
  final copy = List<String>.from(colorList);
  copy.shuffle(Random());
  return copy.sublist(0, n-1);
}

// Category list와 정수 n을 받아 카테고리에 종속되는 n개의 Task를 만듬.
Future<List<Task>> makeTestTask(List<Category> cat, int n) async{
  final rand = Random();
  var list = <Task>[];

  for (int i=0;i<n;i++) {
    // DateTime start = (rand.nextInt(30) + 30).minutes.fromNow;
    DateTime start = _generateTime();
    DateTime end = start + (rand.nextInt(30) + 30).minutes;
    var t = Task(
        'T#${TestTask.index++} ${start.time} - ${end.time}',
        start,
        end,
        cat[rand.nextInt(cat.length)].color,
        // colorList[rand.nextInt(colorList.length)],
        rand.nextInt(1).toBool
    );
    list.add(t);
    dev.log('$t');
  }
  return list;
}
Future<List<Task>> makeTestTaskNonCat(int n) async {
  final rand = Random();

  final list = <Task>[];

  // generate 5 colors from colorList.
  final copiedList = _extractColorList(5);
  for (int i=0;i<n;i++) {
    // DateTime start = (rand.nextInt(30) + 30).minutes.fromNow;
    DateTime start = _generateTime();
    DateTime end = start + (rand.nextInt(30) + 30).minutes;
    var t = Task(
        'T#${TestTask.index++} ${start.clock}-${end.clock}',
        start,
        end,
        copiedList[rand.nextInt(copiedList.length)],
        rand.nextInt(1).toBool
    );
    list.add(t);
    dev.log('$t');
  }
  return list;
}

Future<TestSet> makeTest(int taskN) async {
  final copiedList = _extractColorList(5);
  final catLen = copiedList.length;

  final cat = List<Category>.generate(catLen,
      (index) => Category(
        title: 'Cat#$index',
        color: copiedList[index],
      )
  );
  final tasklist = await makeTestTask(cat, taskN);
  return Tuple2(cat, tasklist);

}
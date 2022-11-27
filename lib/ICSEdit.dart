import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:scrollv2/Task.dart';
import 'package:scrollv2/Category.dart';
import 'package:tuple/tuple.dart';

// https://docs.flutter.dev/cookbook/persistence/reading-writing-files
class ICSEdit {
  File? _ics;
  File? _category;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<void> openICS() async {
    final path = await _localPath;
    _ics = File('$path/data.ics');
    _category = File('$path/category.json');
  }
  Future<void> insertTask(Task t) async {
    await openICS();
    return (t.title, t.start, t.end, t.color, t.chained);
  }
  Future<void> removeTask(Task t, bool chained) async {
    await openICS();

  }
  Future<void> insertCategory(Category c) async {
    await openICS();
    return (c.title, c.color);
  }
  Future<void> removeCategory(Category c) async {
    await openICS();
  }
  Future<List<Task>> getTask() async {
    await openICS();
    final List<Map<String, dynamic>> maps = await openICS();
    return List.generate(maps.length, (i){
      return Task(
        title: maps[i]['UID'],
        start: maps[i]['DSTART'],
        end: maps[i]['DEND'],
        color: maps[i]['CATEGORIES'],
        chained: maps[i]['SUMMARY'] == 1 ? true: false,
      );
    });
  }
  Future<List<Category>> getCategory() async {
    await openICS();
    final List<Task> tasklist = <Task>[];
    return takeList(
      title: maps[i]['UID'],
      color: maps[i]['CATEGORIES']
    );
  }

  // 카테고리, 일정 데이터를 한번에 받기위해 Tuple로 데이터를 리턴해주는 메소드.
  Future<Tuple2<List<Category>, List<Task>>> getCalendarData() async {
    if (_ics == null) { // openICS()가 실행되지 않아 _ics가 null인 경우.
      await openICS();
    }
    return Tuple2(await getCategory(), await getTask());
  }
}

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
  Future<void> insertTask(Task t) async {}
  Future<void> removeTask(Task t, bool chained) async {}
  Future<void> insertCategory(Category c) async {}
  Future<void> removeCategory(Category c) async {}
  Future<List<Task>> getTask() async {}
  Future<List<Category>> getCategory() async {}

  // 카테고리, 일정 데이터를 한번에 받기위해 Tuple로 데이터를 리턴해주는 메소드.
  Future<Tuple2<List<Category>, List<Task>>> getCalendarData() async {
    if (_ics == null) { // openICS()가 실행되지 않아 _ics가 null인 경우.
      await openICS();
    }
    return Tuple2(await getCategory(), await getTask());
  }
}

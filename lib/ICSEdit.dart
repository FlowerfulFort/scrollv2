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
  Future<Tuple2<List<Category>, List<Task>>> getData() async {
    if (_ics == null) {
      await openICS();
    }
    return Tuple2(await getCategory(), await getTask());
  }
}

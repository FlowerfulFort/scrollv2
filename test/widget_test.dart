import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class TaskObject {
  String? title;
  DateTime? start;
  DateTime? end;

  TaskObject(this.title, this.start, this.end);
}

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: SettingPage()),
        extendBody: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  @override
  DateTime _today = DateTime.now();

  List<TaskObject> _tasks = [];

  ExampleScreen() {
    _tasks.add(TaskObject('test1', _today.add(Duration(hours: 1)),
        _today.add(Duration(hours: 2))));
    _tasks.add(TaskObject('test2', _today.add(Duration(hours: 3)),
        _today.add(Duration(hours: 4))));
  }

  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 5.0,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 1, child: _buildTab(widget._today));
  }

  List<Widget> getTasksTiles(var tasks) {
    List<Widget> ret = [];
    for (var task in tasks) {
      ret.add(ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            minimumSize: const Size.fromHeight(30),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Text(
                    "${task.title}\n${DateFormat('a hh:mm', 'ko').format(task.start)} "
                    "~ ${DateFormat('a hh:mm', 'ko').format(task.end)}",
                  )))));
    }
    return ret;
  }

  Widget _buildTab(DateTime today) {
    return InfiniteListView.separated(
      controller: _infiniteController,
      itemBuilder: (BuildContext context, int index) {
        var targetDate = today.add(Duration(days: index));
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              alignment: Alignment.center,
              child: Text(
                DateFormat('dd\nE', 'ko').format(targetDate),
                style: TextStyle(
                  color: targetDate.weekday == DateTime.sunday
                      ? Colors.red
                      : Colors.black,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Column(
                children: [...getTasksTiles(widget._tasks)],
              ),
            ),
            const SizedBox(width: 15)
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1.5, color: Color(0xffAAAAAA)),
      anchor: 0.0,
    );
  }
}

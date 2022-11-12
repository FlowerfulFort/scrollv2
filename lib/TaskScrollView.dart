/* Widget: TaskScrollView
 * 하단에 일정을 보여줄 스크롤뷰.
 * 무한 스크롤을 구현해야 한다.
 * 처음 실행할때 State를 현재 날짜로 하고
 * 특정한 지점으로 이동할때 State를 해당 날짜로 바꾸어 다시 렌더링 하면 될듯..
 */
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:intl/intl.dart';
import 'Task.dart';


class TaskObject {
  String? title;
  DateTime? start;
  DateTime? end;

  TaskObject(this.title, this.start, this.end);
}

class TaskScrollView extends StatefulWidget {
  final Function refreshCallBack;
  final Function getData;
  final List<Task> taskList;
  final DateTime _today = DateTime.now();
  final List<TaskObject> _tasks = [];

  TaskScrollView({required this.refreshCallBack, required this.getData, required this.taskList}) {
    _tasks.add(TaskObject('test1', _today.add(Duration(hours: 1)),
        _today.add(Duration(hours: 2))));
    _tasks.add(TaskObject('test2', _today.add(Duration(hours: 3)),
        _today.add(Duration(hours: 4))));
  }

  _TaskScrollViewState createState() => _TaskScrollViewState();
}

class _TaskScrollViewState extends State<TaskScrollView> {
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
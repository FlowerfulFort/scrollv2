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
import 'dart:developer' as dev;
import 'package:device_calendar/device_calendar.dart';
import 'package:scrollv2/TaskObject.dart';
import 'package:scrollv2/DataQuery.dart';

class TaskScrollView extends StatefulWidget {
  final Function refreshCallBack;
  final Function getData;
  final String cal_id;

  // final List<Task> taskList;
  final DateTime _today = DateTime.now();
  final List<TaskObject> _tasks = [];

  TaskScrollView(
      {required this.refreshCallBack,
      required this.getData,
      required this.cal_id}) {
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

  List<Widget> tasksTiles(var tasks) {
    List<Widget> ret = [];
    for (var task in tasks) {
      ret.add(ElevatedButton(
          onPressed: () {
            // 일단 누르면 log에 일정정보 출력
            dev.log('${task.title}: ${task.start} ~ ${task.end}');
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.all(8)),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${task.title}\n${DateFormat('a hh:mm', 'ko').format(task.start)} "
                "~ ${DateFormat('a hh:mm', 'ko').format(task.end)}",
              ))));
      ret.add(const SizedBox(
        height: 7,
      ));
    }
    return ret;
  }

  Widget taskAddButton(DateTime date) {
    return OutlinedButton(
        onPressed: () {
          setState(() {
            widget._tasks.add(TaskObject('test3', date.add(Duration(hours: 1)),
                date.add(Duration(hours: 2))));
          });
        },
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0),
            ),
            side: BorderSide(width: 2.0, color: Colors.grey)),
        child: const Icon(Icons.add, size: 20, color: Colors.grey));
  }

  Widget _buildTab(DateTime today) {
    return InfiniteListView.separated(
      controller: _infiniteController,
      itemBuilder: (BuildContext context, int index) {
        var targetDate = today.add(Duration(days: index));

        return Column(
          children: [
            if (targetDate.day == 1)
              SizedBox(
                  height: 55,
                  child: DecoratedBox(
                      decoration: const BoxDecoration(color: Color(0xFF364F4D)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "   ${today.add(Duration(days: index + 1)).month}월",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                      ))),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  alignment: Alignment.center,
                  child:

                    CircleAvatar(
                    backgroundColor: index == 0? const Color(0xffffe1b4) : Colors.transparent,
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
                ),
                Expanded(
                  child: dateCell(targetDate),
                ),
                const SizedBox(width: 15)
              ],
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
            thickness: 1.2, height: 1.5, color: Color(0xff999999));
      },
      anchor: 0.0,
    );
  }

  FutureBuilder dateCell(DateTime target) {
    return FutureBuilder(
        future: DataQuery.fetchEvents(widget.cal_id, target),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.hasError) {
            throw Exception("Fetch Error");
          } else {
            return Column(
              children: [
                const SizedBox(height: 7),
                ...tasksTiles(snapshot.data),
                Container(
                    alignment: Alignment.center, child: taskAddButton(target)),
                const SizedBox(height: 4),
              ],
            );
          }
        });
  }
}

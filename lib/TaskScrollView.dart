/* Widget: TaskScrollView
 * 하단에 일정을 보여줄 스크롤뷰.
 * 무한 스크롤을 구현해야 한다.
 * 처음 실행할때 State를 현재 날짜로 하고
 * 특정한 지점으로 이동할때 State를 해당 날짜로 바꾸어 다시 렌더링 하면 될듯..
 */
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;
import 'package:scrollv2/DateCell.dart';
class TaskScrollView extends StatefulWidget {
  final Function refreshCallBack;
  final Function getData;
  final String cal_id;
  // final List<Task> taskList;
  final DateTime _today = DateTime.now();

  TaskScrollView(
      {required this.refreshCallBack,
      required this.getData,
      required this.cal_id});

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
                  child: DateCell(widget.cal_id, targetDate, widget.getData),
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
}

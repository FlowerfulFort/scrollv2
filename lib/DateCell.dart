import 'dart:core';
import 'package:flutter/material.dart';
import 'package:scrollv2/DataQuery.dart';
import 'package:intl/intl.dart';
import 'package:scrollv2/TaskObject.dart';
import 'dart:developer' as dev;
class DateCell extends StatefulWidget {
  String cal_id;
  DateTime target;
  Function getData;
  DateCell(this.cal_id, this.target, this.getData);
  @override
  DateCellState createState() => DateCellState();
}
class DateCellState extends State<DateCell> {
  late Future<List<TaskObject>> _futureTask;
  @override
  void initState() {
    _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.target);
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
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
  Widget taskAddButton() {
    return OutlinedButton(
      onPressed: () async {
        final data = widget.getData();
        DataQuery.createEvent(widget.cal_id, widget.target, data).then((param) {
          setState(() {
            _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.target);
          });
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),),
        side: const BorderSide(width: 2.0, color: Colors.grey)
      ),
      child: const Icon(Icons.add, size: 20, color: Colors.grey));
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureTask,
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
                    alignment: Alignment.center,
                    child: taskAddButton()),
                const SizedBox(height: 4),
              ],
            );
          }
        }
    );
  }
}
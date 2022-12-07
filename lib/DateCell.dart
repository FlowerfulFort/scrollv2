import 'dart:core';
import 'package:flutter/material.dart';
import 'package:scrollv2/DataQuery.dart';
import 'package:intl/intl.dart';
import 'package:device_calendar/device_calendar.dart';

import 'EventModify.dart';
class DateCell extends StatefulWidget {
  String cal_id;
  DateTime targetDate;
  Function getData;
  DateCell(this.cal_id, this.targetDate, this.getData);
  @override
  DateCellState createState() => DateCellState();
}
class DateCellState extends State<DateCell> {
  late Future<List<Event>> _futureTask;
  @override
  void initState() {
    _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.targetDate);
  }
  List<Widget> tasksTiles(var events) {
    List<Widget> ret = [];
    for (Event event in events) {
      ret.add(ElevatedButton(
          onPressed: () async {
            // 일단 누르면 log에 일정정보 출력
            await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context){
              return CalendarEventPage(
                Calendar(id:widget.cal_id, isReadOnly: false),
                event,
              );
            }));
            setState(() {
              _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.targetDate);
            });
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              backgroundColor: Colors.lightBlue,
              padding: const EdgeInsets.all(8)),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${event.title}\n${DateFormat('a hh:mm', 'ko').format(event.start!.toDateTime)} "
                    "~ ${DateFormat('a hh:mm', 'ko').format(event.end!.toDateTime)}",
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
        DataQuery.createEvent(widget.cal_id, widget.targetDate, data).then((param) {
          setState(() {
            _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.targetDate);
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
  void didUpdateWidget(Widget oldWidget) {
    oldWidget as DateCell;
    // Auto-update when calender_id changed.
    if (widget.cal_id != oldWidget.cal_id) {
      _futureTask = DataQuery.fetchEvents(widget.cal_id, widget.targetDate);
    }
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


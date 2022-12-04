import 'package:flutter/material.dart';
import 'package:time/time.dart';
import 'dart:developer' as dev;
import 'package:scrollv2/style.dart';
extension Formating on int {
  String get f2 => this<10 ? '0$this' : toString();
}
extension TimeParse on TimeOfDay {
  String get toStr12 {
    var after = '오전';
    var target = hour;
    if (hour>=12) after = '오후';
    if (hour>12) target -= 12;
    return '$after ${target.f2}:${minute.f2}';
  }
  // String get toStr12 => '${hour>=12 ? '오후 ${(hour-12).f2}' : '오전 ${hour.f2}'}:${minute.f2}';
  String get toStr24 => '${hour.f2}:${minute.f2}';
  String fmt(int mode) {
    return mode==0 ? toStr12 : toStr24;
  }
}
const p0 = TimeOfDay(hour: 0, minute: 0);
const p24 = TimeOfDay(hour:23, minute: 59);

class DurationPicker extends StatefulWidget {
  final Function(TimeOfDay, TimeOfDay) _sendCallback;  // send data to parent using callback.
  final int mode;   // mode=0: am/pm , mode=1: 24time
  DurationPicker(this.mode, this._sendCallback);
  @override
  DurationPickerState createState() => DurationPickerState();
}
class DurationPickerState extends State<DurationPicker> {
  late TimeOfDay _start;
  late TimeOfDay _end;
  late bool allday;
  void _pickStart(TimeOfDay t) {  // Callback function for TimePicker
    _start = t;
    widget._sendCallback(_start, _end);
  }
  void _pickEnd(TimeOfDay t) {    // Callback function for TimePicker
    _end = t;
    widget._sendCallback(_start, _end);
  }
  @override
  void initState() {
    // State Initialization.
    DateTime n = DateTime.now();
    _start = TimeOfDay.fromDateTime(n);
    _end = TimeOfDay.fromDateTime(n + 30.minutes);
    widget._sendCallback(_start, _end);
    allday = false;
  }
  @override
  Widget build(BuildContext context) {
    const double MARGIN_LR = 24;
    const double ICON_SIZE = 30;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded( // TimePicker: start
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: MARGIN_LR),
                  child: TimePicker(_start, widget.mode, allday, _pickStart),
                ),
              ),
              Container(  // Arrow Icon
                // margin: const EdgeInsets.only(left: MARGIN_LR, right: MARGIN_LR),
                child: const Icon(Icons.arrow_forward_outlined, size: ICON_SIZE, color: Colors.white),
              ),
              Expanded( // TimePicker: end
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(right: MARGIN_LR),
                  child: TimePicker(_end, widget.mode, allday, _pickEnd),
                ),
              ),
            ],
          ),
        ),
        Container(  // All-day Switcher.
          // width: 40,
          // height: 40,
          padding: const EdgeInsets.all(0),
          // margin: const EdgeInsets.only(left: 40),
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                allday = !allday;
                if (allday) {                     // if allday == true,
                  widget._sendCallback(p0, p24);  // 00:00 - 23:59.
                } else {
                  widget._sendCallback(_start, _end);
                }
                // mode = mode==0 ? 1 : 0;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(6),
              side: const BorderSide(color: Colors.white, width: 3),
              backgroundColor: allday ? Colors.white : const Color.fromARGB(0, 255, 255, 255),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('24',
              style: (allday ? intaglioStyle : normalStyle),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class TimePicker extends StatefulWidget {
  final TimeOfDay _time;
  final int _mode;
  final bool _allday;
  Function(TimeOfDay) callback;
  TimePicker(this._time, this._mode, this._allday, this.callback);
  @override
  TimePickerState createState() => TimePickerState();
}
class TimePickerState extends State<TimePicker> {
  late TimeOfDay _time;

  @override
  void initState() {
    _time = widget._time;
  }

  /*
  @override
  void didUpdateWidget(Widget oldWidget) {
    TimePicker old = oldWidget as TimePicker;
    dev.log('didupdatewidget: oldwidget: ${old._allday} now: ${widget._allday}');
    if (!old._allday && (old._allday != widget._allday)) {
      // allday state changed false to true...
      widget.callback();  // time update to default time(00:00 - 23:59).
      return;
    }
    if (old._allday && (old._allday != widget._allday)) {
      // allday state changed true to false...
      widget.callback(_time); // time update to time in state (start - end).
      return;
    }
  }
  */
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(_time.fmt(widget._mode), style: widget._allday ? disabledStyle : boldStyle),
      onPressed: () {
        /* Open Window to pick time. */
        if (widget._allday) return;
        Future<TimeOfDay?> selected = showTimePicker(context: context, initialTime: _time);
        selected.then((picked) {
          setState(() {
            if (picked != null) {
              _time = picked;
              widget.callback(picked);  // send to parent state
            }
          });   // setState Callback
        });   // selected.then Callback
      }   // onPressed Callback
    );
  }
}
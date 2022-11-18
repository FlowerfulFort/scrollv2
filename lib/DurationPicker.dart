import 'package:flutter/material.dart';
import 'package:time/time.dart';
import 'dart:developer' as dev;
import 'package:scrollv2/style.dart';
extension Formating on int {
  String get f2 => this<10 ? '0$this' : toString();
}
extension TimeParse on TimeOfDay {
  String get toStr12 => '${hour>12 ? '오후 ${(hour-12).f2}' : '오전 ${hour.f2}'}:${minute.f2}';
  String get toStr24 => '${hour.f2}:${minute.f2}';
  String fmt(int mode) {
    return mode==0 ? toStr12 : toStr24;
  }
}

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
  late int mode;
  void _pickStart(TimeOfDay t) {
    _start = t;
    widget._sendCallback(_start, _end);
  }
  void _pickEnd(TimeOfDay t) {
    _end = t;
    widget._sendCallback(_start, _end);
  }
  @override
  void initState() {
    DateTime n = DateTime.now();
    _start = TimeOfDay.fromDateTime(n);
    _end = TimeOfDay.fromDateTime(n + 30.minutes);
    widget._sendCallback(_start, _end);
    mode = widget.mode;
  }
  @override
  Widget build(BuildContext context) {
    const double MARGIN_LR = 24;
    const double ICON_SIZE = 24;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: MARGIN_LR),
                  child: TimePicker(_start, mode, _pickStart),
                ),
              ),
              Container(
                // margin: const EdgeInsets.only(left: MARGIN_LR, right: MARGIN_LR),
                child: const Icon(Icons.arrow_forward_outlined, size: 30, color: Colors.white),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(right: MARGIN_LR),
                  child: TimePicker(_end, mode, _pickEnd),
                ),
              ),
            ],
          ),
        ),
        Container(  // 12/24 time selector
          // width: 40,
          // height: 40,
          padding: const EdgeInsets.all(0),
          // margin: const EdgeInsets.only(left: 40),
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                mode = mode==0 ? 1 : 0;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(6),
              side: const BorderSide(color: Colors.white, width: 3),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text((mode==0 ? 12 : 24).toString(),
              style: normalStyle,
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
  Function(TimeOfDay) callback;
  TimePicker(this._time, this._mode, this.callback);
  @override
  TimePickerState createState() => TimePickerState();
}
class TimePickerState extends State<TimePicker> {
  late TimeOfDay _time;

  @override
  void initState() {
    _time = widget._time;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(_time.fmt(widget._mode), style: boldStyle),
      onPressed: () {
        Future<TimeOfDay?> selected = showTimePicker(context: context, initialTime: _time);
        selected.then((picked) {
          setState(() {
            if (picked != null) {
              _time = picked;
              widget.callback(picked);
            }
          });   // setState Callback
        });   // selected.then Callback
      }   // onPressed Callback
    );
  }
}
/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scrollv2/style.dart';
import 'package:time/time.dart';
import 'package:scrollv2/TaskScrollView.dart';
import 'package:scrollv2/CategoryView.dart';
import 'package:scrollv2/TestSet.dart';
import 'dart:developer' as dev;
import 'package:scrollv2/DurationPicker.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:scrollv2/PreferenceModify.dart';

class AddTaskForm extends StatefulWidget {
  AppPreference app;
  AddTaskForm(this.app);
  @override
  AddTaskFormState createState() => AddTaskFormState();
}
class AddTaskFormState extends State<AddTaskForm> {
  TextStyle style = const TextStyle(
    color: Colors.lightGreen,
    fontSize: 35,
  );
  late TimeOfDay _start, _end;
  late Calendar _calendar;
  final titleController = TextEditingController();
  late int hourmode;
  /* test data.. */
  void setDuration(TimeOfDay s, TimeOfDay e) {
    _start = s; _end = e;
  }
  void getData() => {
    'title': titleController.value.text,
    'startTime': _start,
    'endTime': _end
  };
  void render() => setState(() {});
  @override
  void initState() {
    /* Preference Settings. */
    hourmode = widget.app.hourmod;
    // for debugging.
    Timer.periodic(5.seconds, (timer) {
      dev.log('$_start, $_end');
    });
    // TODO: to be changed to get parameter from settings.json
  }

  @override
  Widget build(BuildContext context) {
    dev.log('Render: AddTaskForm');
    return FutureBuilder(
      future: makeTest(10),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          dev.log('Error Occurred at FutureBuilder: ${snapshot.error}');
          return Center(child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ));
        }
        else {
          return Column(
            children: <Widget>[
              CategoryView(refreshCallBack: render, categoryList: snapshot.data.item1),
              Container(    // body of AddTaskForm.
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 5, right: 5),
                color: bgColor,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(   // Menu Button
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () { // Expand ContextMenu Handling
                            dev.log('Pressed menu button');
                          },
                        ),
                        Expanded(child: TextField(  // Input Title
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: '제목',
                          ),
                        )),
                        IconButton(   // ExpandView Button
                          icon: const Icon(Icons.article_outlined, color: Colors.white, size: 36),
                          onPressed: () { //
                            dev.log('Pressed view button');
                          },
                        )
                      ]
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(right: 5),
                      child: DurationPicker(hourmode, setDuration),
                    ),
                  ],
                ),
              ),
              Expanded(child: TaskScrollView(
                  refreshCallBack: render,
                  getData: getData,
                  cal_id: widget.app.cal_id,
              )),
            ],
          );
        }
      },
    );
  }
}

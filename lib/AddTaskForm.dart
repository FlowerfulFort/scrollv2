/* Widget: AddTaskForm
 * Stateless로 하는게 낫나? 모르겠다.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollv2/style.dart';
import 'package:time/time.dart';
// import 'ICSEdit.dart';
import 'package:scrollv2/TaskScrollView.dart';
import 'package:scrollv2/CategoryView.dart';
// import 'package:scrollv2/Category.dart';
import 'package:scrollv2/TestSet.dart';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:scrollv2/DurationPicker.dart';

class AddTaskForm extends StatefulWidget {
  @override
  AddTaskFormState createState() => AddTaskFormState();
}
class AddTaskFormState extends State<AddTaskForm> {
  TextStyle style = const TextStyle(
    color: Colors.lightGreen,
    fontSize: 35,
  );
  late TimeOfDay _start, _end;
  late int datemode;
  // late var _debug;
  // bool filtering = false;
  // Category? filtered;
  final titleController = TextEditingController();

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
    // for debugging.
    Timer.periodic(5.seconds, (timer) {
      dev.log('$_start, $_end');
    });
    // TODO: to be changed to get parameter from settings.json
    datemode = 0; // 0=am/pm, 1=24hours
  }

  @override
  Widget build(BuildContext context) {
    dev.log('Render: AddTaskForm');
    // dev.log(icsHeader);
    // ICSEdit a = ICSEdit();
    // a.localPath.then((path) {
    //   dev.log('ICSEdit: $path');
    // });
    return FutureBuilder(
      future: makeTest(20),
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
          // 생성된 테스트 List<Task>를 받아서(snapshot.data.item2) ICS 파일을 쓴 후,
          // 다시 그 파일을 읽어 log로 확인하는 모습입니다.
          makeICSTest(snapshot.data.item2).then((resolve) async {
            dev.log('ICS Written');
            final dir = (await getApplicationDocumentsDirectory()).path;
            final ics = File('$dir/data.ics');
            final data = ics.readAsStringSync();    // file read.
            dev.log('ICSDATA:\n$data');             // print to log.
          });
          /* !!!!!!!!! else부터 return Column까지 공간에 테스트할 메소드를 넣어주세요 !!!!!!!!!!!*/
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
                      child: DurationPicker(datemode, setDuration),
                    ),
                    // TextField(
                    //     controller: titleController,
                    //     decoration: const InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         labelText: '제목'
                    //     )
                    // ),
                    // FloatingActionButton(
                    //     child: const Icon(Icons.print),
                    //     onPressed: () async {
                    //       dev.log('Re-render after 3 seconds...');
                    //       await Future.delayed(3.seconds);
                    //       dev.log(titleController.text);
                    //       titleController.clear();
                    //       render();
                    //       // widget.refreshCallBack();
                    //     }
                    // )
                  ],
                ),
              ),
              Expanded(child: TaskScrollView(
                  refreshCallBack: render,
                  getData: getData,
                  taskList: snapshot.data.item2
              )),
            ],
          );
        }
      },
    );
  }
}

Future<void> testmethod() async {
  await Future.delayed(2.seconds, () {
    dev.log('2sec delayed!');
  });
}
import 'package:flutter/material.dart';
import 'package:scrollv2/PreferenceModify.dart';
import 'package:scrollv2/DataQuery.dart';
class SettingPage extends StatefulWidget{
  AppPreference app;
  SettingPage(this.app);
  @override
  SettingPageState createState() => SettingPageState();
}
class SettingPageState extends State<SettingPage> {
  late AppPreference app;
  @override
  void initState() {
    app = widget.app;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, app);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text("설정")
          ),
          body: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile( //checkbox positioned at right
                          value: app.hourmod==1 ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              app.hourmod = (value!) ? 1 : 0;
                            });
                          },
                          title: const Text("24시간 표시",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: const Text("시간을 오전/오후 표시 대신 24시간으로 표시합니다.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          )
                      ),
                    ],)
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text("알람 시간",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: const Text("일정 시간이 되기 N분 전에 푸쉬 알림을 보냅니다.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      trailing: DropdownButton(
                        items: const [
                          DropdownMenuItem(
                            value: "10",
                            child: Text("10분 전"),
                          ),
                          DropdownMenuItem(
                            value: "30",
                            child: Text("30분 전"),
                          ),
                          DropdownMenuItem(
                            value: "60",
                            child: Text("1시간 전"),
                          ),
                        ], value: app.alarm_time.toString(),
                        onChanged: (String? value) {
                          setState(() {
                            app.alarm_time = int.parse(value!);
                          });
                        }
                      ),
                    ),
                  ],
                )
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))
                ),
                child: PopupMenuButton(
                  child: const ListTile(
                    title: Text("표시 캘린더 변경",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text("화면에 표시될 캘린더를 변경합니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    )
                  ),
                  itemBuilder: (BuildContext context) {
                    final keys = DataQuery.getCalendars();
                    return keys.map((c) {
                      return PopupMenuItem<String>(
                        value: c,
                        child: Text(c)
                      );
                    }).toList();
                  },
                  onSelected: (String value) {
                    app.cal_id = value;
                  }
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool? check = false;
  String? choice = "10분 전";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("설정")
      ),
      body: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile( //checkbox positioned at right
                      value: check,
                      onChanged: (bool? value) {
                        setState(() {
                          check = value;
                        });
                      },
                      title: Text("24시간 표시",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text("시간을 오전/오후 표시 대신 24시간으로 표시합니다.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      )
                  ),
                ],)
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text("알람 시간",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text("일정 시간이 되기 N분 전에 푸쉬 알림을 보냅니다.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      trailing: DropdownButton(
                          items: [
                            DropdownMenuItem(
                              value: "10분 전",
                              child: Text("10분 전"),
                            ),
                            DropdownMenuItem(
                              value: "30분 전",
                              child: Text("30분 전"),
                            ),
                            DropdownMenuItem(
                              value: "1시간 전",
                              child: Text("1시간 전"),
                            ),
                          ], value: choice,
                          onChanged: (String? value) {
                            setState(() {
                              choice = value;
                            });
                          }
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }
                  ),
                ],)
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
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
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }
                  )
                ],)
          ),
        ],),
    );
  }
}
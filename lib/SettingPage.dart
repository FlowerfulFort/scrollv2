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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("설정")
        ),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top:20, left:20, right:20),
                alignment: Alignment.topLeft,
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
                        title: Text("24시간 표시"),
                        subtitle: Text("시간을 오전/오후 표시 대신 24시간으로 표시합니다.")
                    ),
                  ],)
            ),
            Container(
              child: Column(
                children: [
                  ListTile(
                      title: Text("알람 시간"),
                      subtitle: Text("일정 시간이 되기 N분 전에 푸쉬 알림을 보냅니다.")
                  )
                ],
              )
            ),
          ],
        ),
    );
  }
}
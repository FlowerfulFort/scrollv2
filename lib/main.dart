import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scrollv2/AddTaskForm.dart';
import 'package:scrollv2/PreferenceModify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollv2/DataQuery.dart';
import 'dart:developer' as dev;
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  Future<AppPreference> readPref() async {
    try {
      await DataQuery.init();
      await PreferenceMod.initPreference();
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      exit(1);
    }
    AppPreference app = PreferenceMod.readPreferenceSync();
    return app;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scroll',
      home: Scaffold(
        body: SafeArea(   // 또는, padding을 상태창 높이만큼 주면 됨. MediaQuery.of(context).padding.top;
          child: FutureBuilder(
            future: readPref(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                Fluttertoast.showToast(msg: 'Error required at calling Preference.');
                exit(0);
              } else {
                return AddTaskForm(snapshot.data);
              }
            }
          )
          // child: AddTaskForm(),
        ),
        extendBody: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Scroll',
//       home: Scaffold(
//         body: SafeArea(   // 또는, padding을 상태창 높이만큼 주면 됨. MediaQuery.of(context).padding.top;
//           child: Container(
//             child: Column(
//               children: [
//                 CategoryView(refreshCallBack: refresh),
//                 AddTaskForm(refreshCallBack: refresh),
//                 Expanded(child: TaskScrollView(refreshCallBack: refresh)),
//               ],
//             ),
//           ),
//         ),
//         extendBody: true,
//       ),
//     );
//   }
// }
class TestGround extends StatelessWidget {
  TestGround();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: 100,
          child: Text('Item 1 - pretty big!'),
          color: Colors.red,
        ),
        Container(
          height: 100,
          child: Text('Item 2'),
          color: Colors.blue,
        ),
        Container(
          height: 100,
          child: Text('Item 3'),
          color: Colors.orange,
        ),
      ],
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <int>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);
  @override
  Widget build(BuildContext context) {
    final randomVal = Random().nextInt(100);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Startup Int Generator'),
      // ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if(i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(_buildInts(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }
  Widget _buildRow(int num) {
    return ListTile(
      title: Text(
        num.toString(),
        style: _biggerFont,
      ),
    );
  }
  List<int> _buildInts(int n) {
    final list = <int>[];
    for (int i=0;i<n;i++) {
      list.add(Random().nextInt(100));
    }
    return list;
  }
}
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
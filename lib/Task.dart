extension TimeParse on DateTime{
  String get clock => '$hour2:$minute2';                      // 시간을 문자열로 리턴.
  String get time => '$month/$day $clock';                    // 날짜와 시간을 문자열로 리턴.
  String get hour2 => '${hour<10 ? '0$hour' : hour}';         // 두자릿수 hour
  String get minute2 => '${minute<10 ? '0$minute' : minute}'; // 두자릿수 minute
  String get serialize {  // DTSTART, DTEND에 들어가기 위한 문자열을 빌드하는 getter.
    var temp = toIso8601String();
    temp = temp.substring(0, temp.indexOf('.'));
    temp = temp.split(RegExp(r'[-:]')).join();
    if (isUtc) temp += 'Z';
    return temp;    // yyyymmddThhmmss(Z) 형태. 예를들면 2022년 11월 14일 13시 45분 00초 일정이라면,
                    // 20221114T134500을 리턴. 시간대가 UTC면 뒤에 Z가 붙음(서울은 GMT+9 기준이므로 없음).
  }
}

const VEVENT_HEADER = 'BEGIN:VEVENT';
const VEVENT_FOOTER = 'END:VEVENT';
class Task {
  static int sequence = 0;  // SEQUENCE를 독립적으로 붙이기 위한 변수.
  Task(this.title, this.start, this.end, this.color, this.alarm);
  Task.na(this.title, this.start, this.end, this.color);
  String title;   // 타이틀.
  DateTime start; // 시작시간
  DateTime end;   // 종료시간
  bool? alarm;    // 알람여부
  String color;   // CSS3 Color keyword(색깔을 나타냄과 동시에 카테고리와 직결되는 항목입니다.)
  String get clock => '${start.hour2}:${start.minute2}';    // Task의 시작시간을 문자열로 리턴해주는 디버깅용 getter.
  String get time => '${start.month}/${start.day} $clock';  // Task의 시작날짜와 시간을 문자열로 리턴해주는 디버깅용 getter.
  String get vevent =>  // ICS파일의 VEVENT 항목을 만들어줌.. 나중에 수정될 수 있음.
      // 각 항목들은 직관적이니 이해하실거라 생각합니다.
      // https://developers.worksmobile.com/kr/document/1007011?lang=ko 을 참조하시면 이해하기 쉬울겁니다.
      '$VEVENT_HEADER\n'
      'UID:${title.split(RegExp(r'[- /:.]')).join()}_${start.serialize}\n'
      'DTSTART:${start.serialize}\n'
      'DTEND:${end.serialize}\n'
      'CREATED:${DateTime.now().serialize}\n'
      'COLOR:$color\n'
      'LAST-MODIFIED:${DateTime.now().serialize}\n'
      'LOCATION:\n'
      'SEQUENCE:${Task.sequence++}\n'
      'SUMMARY:$title\n'
      '$VEVENT_FOOTER\n';
  @override
  String toString() => 'TestTask: $title time: $start ~ $end';
}


/* make test task list, size=n
List<Task> makeTestTask(int n) {

  var list = <Task>[];
  const String testTitle = 'Test title #';
  for (int i=0;i<n;i++) {
    DateTime start = (Random().nextInt(30) + 30).minutes.fromNow;
    DateTime end = start + (Random().nextInt(30) + 30).minutes;
    var t = Task.na(
      testTitle + TestTask.index.toString(),
      start,
      end,
      Colors.blue
    );
    TestTask.index++;
    list.add(t);
    dev.log('$t');
  }
  //var a = Task('123',DateTime.now(), DateTime.now(), false);
  // var list2 = <Task>[
  //   for (int i=0;i<n;i++) Task(
  //     testTitle + i.toString(),
  //     (Random().nextInt(3)+1).days.fromNow,
  //     Random().nextInt(24).hours + Random().nextInt(60).minutes,
  //     start + (Random().nextInt(30) + 30).minutes,
  //     false
  //   )
  // ];
  return list;
}
*/
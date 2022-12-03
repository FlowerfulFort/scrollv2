import 'package:device_calendar/device_calendar.dart';
import 'package:scrollv2/TaskObject.dart';
import 'package:timezone/timezone.dart';
import 'dart:developer' as dev;
extension tzparse on TZDateTime {
  DateTime get toDateTime => DateTime(
    year, month, day, hour, minute, second
  );
}
const Duration oneDay = Duration(days: 1);
class DataQuery {
  static final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();
  static bool isInitiated = false;
  static Future<void> init() async {
    final perm = await _plugin.hasPermissions();
    if (!perm.isSuccess) {
      throw Exception('Perm Error.');
    }
    if(perm.data!) {  // if has permission.
      isInitiated = true;
      return;
    }
    final afterReq = await _plugin.requestPermissions();
    if (!afterReq.isSuccess) {
      throw Exception('Perm Error.');
    }
    if(afterReq.data!) {
      isInitiated = true;
      return;
    }
    // tail recursion.
    await init();
  }
  static RetrieveEventsParams makeParam(DateTime fetchDate) {
    DateTime start = DateTime(fetchDate.year, fetchDate.month, fetchDate.day);
    DateTime end = start.add(oneDay);
    return RetrieveEventsParams(
      startDate: start,
      endDate: end
    );
  }
  static Future<List<TaskObject>> fetchEvents(String cal_id, DateTime fetchDate) async {
    cal_id = "4"; // 디버그용으로 임시로 지정해줌
    if (!isInitiated) init();
    final res = await _plugin.retrieveEvents(cal_id, makeParam(fetchDate));
    if (!res.isSuccess) throw Exception('RetrieveEvents failed: $fetchDate');
    final rawList = res.data!;
    return rawList.map((event) {
      return TaskObject(event.title, event.start!.toDateTime, event.end!.toDateTime);
    }).toList();
  }
}
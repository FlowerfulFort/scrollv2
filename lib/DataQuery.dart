import 'dart:collection';

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
  static final Map<String, List<String>> calMap = {};
  static bool isInitiated = false;
  static Future<void> init() async {
    final perm = await _plugin.hasPermissions();
    if (!perm.isSuccess) {
      throw Exception('Perm Error.');
    }
    if(perm.data!) {  // if has permission.
      _initMap();
      isInitiated = true;
      return;
    }
    final afterReq = await _plugin.requestPermissions();
    if (!afterReq.isSuccess) {
      throw Exception('Perm Error.');
    }
    if(afterReq.data!) {
      _initMap();
      isInitiated = true;
      return;
    }
    // tail recursion.
    await init();
  }
  static Future<void> _initMap() async {
    final cals = await _plugin.retrieveCalendars();
    if(!cals.isSuccess) throw Exception('RetrieveCalendars Error');
    for (var c in cals.data!) {
      if (!calMap.containsKey(c.accountName!)) {
        calMap[c.accountName!] = <String>[];
      }
      calMap[c.accountName!]?.add(c.id!);
    }
  }
  static RetrieveEventsParams makeParam(DateTime fetchDate) {
    DateTime start = DateTime(fetchDate.year, fetchDate.month, fetchDate.day);
    DateTime end = start.add(oneDay);
    return RetrieveEventsParams(
      startDate: start,
      endDate: end
    );
  }
  static Future<List<TaskObject>> fetchEvents(String cal_acc, DateTime fetchDate) async {
    if (!isInitiated) init();
    final rawList = <Event>[];
    for (var c in calMap[cal_acc]!) {
      final events = await _plugin.retrieveEvents(c, makeParam(fetchDate));
      if (!events.isSuccess) dev.log('RetrieveEvents Error');
      rawList.addAll(events.data!);
    }
    // final res = await _plugin.retrieveEvents(cal_acc, makeParam(fetchDate));
    // if (!res.isSuccess) throw Exception('RetrieveEvents failed: $fetchDate');
    // final rawList = res.data!;
    return rawList.map((event) {
      return TaskObject(event.title, event.start!.toDateTime, event.end!.toDateTime);
    }).toList();
  }
}
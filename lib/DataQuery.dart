import 'dart:io';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:scrollv2/TaskObject.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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
  static final Map<String, String> calMapId = {};
  static late final String tz;
  static bool isInitiated = false;
  static Future<void> init() async {
    tz = await FlutterNativeTimezone.getLocalTimezone();
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
      if (!(c.isReadOnly!)) calMapId[c.accountName!] = c.id!;
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
  static Future<void> createEvent(String cal_id, DateTime date, Map<String, dynamic> data) async {
    // TODO: calMap[cal_id]!"[0]" must be changed later..
    final Event event = Event(calMapId[cal_id]![0],
      title: data['title'],
      start: _time2TZ(date, data['startTime']),
      end: _time2TZ(date, data['endTime'])
    );
    Result<String>? res = await _plugin.createOrUpdateEvent(event);
    if (!res!.isSuccess) {
      dev.log('failed to create event');
    } else {
      dev.log('created event id: ${res.data}');
    }
  }
  static List<String> getCalendars() {
    return calMap.keys.toList();
  }
  static TZDateTime _time2TZ(DateTime dt, TimeOfDay time) => TZDateTime(
    getLocation(tz),
    dt.year, dt.month, dt.day, time.hour, time.minute
  );
}
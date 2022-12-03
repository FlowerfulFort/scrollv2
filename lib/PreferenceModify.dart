import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

const link = 'preference.json';
const default_hourmod = 0;
const default_alarm_time = 30;
const exception_msg = 'Preference was not initiated.';
class PreferenceMod {
  static late final String _path;
  static bool isInitiated = false;
  static Future<void> initPreference() async {
    final docs = await getApplicationDocumentsDirectory();
    _path = '${docs.path}/$link';
    final file = File(_path);
    if (!file.existsSync()) {
      final plugin = DeviceCalendarPlugin();
      final cals = await plugin.retrieveCalendars();
      late String cal_id;
      if (cals.isSuccess && (cals.data != null)) {
        for (var c in cals.data!) {   // default phone calendar.
          if (c.id == '1') {
            cal_id = c.accountName!;
          }
          if (c.accountType == 'com.google') {  // high priority to google calendar.
            cal_id = c.accountName!;
            break;
          }
        }
        await Fluttertoast.showToast(msg: "Default account is $cal_id");
      } else {
        await Fluttertoast.showToast(msg: "Calendar does not exists...");
        exit(1);
      }
      final app = AppPreference(
        cal_id: cal_id,
        alarm_time: default_alarm_time,
        hourmod: default_hourmod
      );
      file.writeAsStringSync(jsonEncode(app.toMap));
    }
    isInitiated = true;
  }
  static void createPreferenceSync(AppPreference app) {
    if (!isInitiated) throw Exception(exception_msg);
    final target = File(_path);
    target.writeAsStringSync(jsonEncode(app.toMap));
  }
  static Future<void> createPreference(AppPreference app) async {
    if (!isInitiated) await initPreference();
    createPreferenceSync(app);
    // final target = File(_path);
    // target.writeAsStringSync(jsonEncode(app.toMap));
  }
  static AppPreference readPreferenceSync() {
    if (!isInitiated) throw Exception(exception_msg);
    final target = File(_path);
    String serialized = target.readAsStringSync();
    return AppPreference.fromJson(serialized);
  }
  static Future<AppPreference> readPreference() async {
    if(!isInitiated) await initPreference();
    return readPreferenceSync();
    // final target = File(_path);
    // String serialized = target.readAsStringSync();
    // return AppPreference.fromJson(serialized);
  }
}
class AppPreference {
  late String cal_id;
  late int alarm_time;
  late int hourmod;
  AppPreference({required this.cal_id, required this.alarm_time, this.hourmod=0});
  AppPreference.fromMap(Map<String, dynamic> m) {
    cal_id = m['cal_id'];
    alarm_time = m['alarm_time'];
    hourmod = m['hourmod'];
  }
  AppPreference.fromJson(String json) {
    Map<String, dynamic> m = jsonDecode(json);
    cal_id = m['cal_id'];
    alarm_time = m['alarm_time'];
    hourmod = m['hourmod'];
  }
  Map<String, dynamic> get toMap => {
    'cal_id': cal_id,
    'alarm_time': alarm_time,
    'hourmod': hourmod,
  };
}
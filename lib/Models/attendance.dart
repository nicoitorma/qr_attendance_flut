import 'package:intl/intl.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class AttendanceModel {
  int? id;
  String? attendanceName;
  String? details;
  String? timeAndDate;
  String? cutoff;

  AttendanceModel(
      {this.id,
      this.attendanceName,
      this.details,
      this.timeAndDate,
      this.cutoff});

  AttendanceModel.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        attendanceName = item['attendanceName'] ?? '',
        details = item['details'] ?? '',
        timeAndDate = item['timeAndDate'],
        cutoff = item['cutoff'] ?? '';

  Map<String, Object> toMap() {
    return {
      'attendanceName': attendanceName!,
      'details': details ?? '',
      'timeAndDate':
          DateFormat(labelDateFormat).format(DateTime.now()).toString(),
      'cutoff': cutoff ?? ''
    };
  }
}

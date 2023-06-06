import 'package:intl/intl.dart';

class AttendanceModel {
  int? id;
  String? attendanceName;
  String? details;
  String? dateTime;
  String? cutoff;

  AttendanceModel(
      {this.id, this.attendanceName, this.details, this.dateTime, this.cutoff});

  AttendanceModel.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        attendanceName = item['attendanceName'] ?? '',
        details = item['details'] ?? '',
        dateTime = item['dateTime'],
        cutoff = item['cutoff'] ?? '';

  Map<String, Object> toMap() {
    return {
      'attendanceName': attendanceName!,
      'details': details ?? '',
      'dateTime':
          DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.now()).toString(),
      'cutoff': cutoff ?? ''
    };
  }
}

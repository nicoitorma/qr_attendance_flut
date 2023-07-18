import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class AttendanceModel {
  int? id;
  String? attendanceName;
  String? details;

  DateTime? date;
  DateTime? time;

  /// timeAndDate and attendanceCode is to be used for firebase firestore
  DateTime? timeAndDate;
  String? attendanceCode;
  String? cutoffTimeAndDate;
  String? user;

  AttendanceModel(
      {this.id,
      this.attendanceName,
      this.details,
      this.date,
      this.time,
      this.timeAndDate,
      this.attendanceCode,
      this.cutoffTimeAndDate,
      this.user});

  factory AttendanceModel.fromDocumentSnapshot(String code, Map data) {
    return AttendanceModel(
        attendanceCode: code,
        attendanceName: data['attendanceName'] ?? '',
        details: data['details'] ?? '',
        timeAndDate: (data['timeAndDate'] as Timestamp).toDate(),
        cutoffTimeAndDate: data['cutoff'],
        user: data['users'][0]);
  }

  AttendanceModel.fromJson(Map<String, dynamic> item)
      : id = item['aId'] ?? '',
        attendanceName = item['attendanceName'] ?? '',
        details = item['details'] ?? '',
        date = DateFormat(labelDateFormat).parse(item['date']),
        time = DateFormat(labelTimeFormat).parse(item['time']),
        cutoffTimeAndDate = item['cutoffTimeAndDate'] ?? '';

  Map<String, Object> toMap() {
    return {
      'attendanceName': attendanceName!,
      'details': details ?? '',
      'date': DateFormat(labelDateFormat).format(DateTime.now()),
      'time': DateFormat(labelTimeFormat).format(DateTime.now()),
      'cutoffTimeAndDate': cutoffTimeAndDate ?? '',
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentInAttendance {
  int? id;
  String? idNum;
  String? fullname;
  String? dept;
  int? attendanceId;
  String? timeAndDate;
  String? isLate;

  StudentInAttendance(
      {this.idNum,
      this.fullname,
      this.dept,
      this.attendanceId,
      this.timeAndDate,
      this.isLate});

  StudentInAttendance.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        idNum = item['idNum'] ?? '',
        fullname = item['fullname'] ?? '',
        dept = item['dept'] ?? '',
        attendanceId = item['attendanceId'] ?? '',
        timeAndDate = item['timeAndDate'] ?? '',
        isLate = item['isLate'];

  factory StudentInAttendance.fromDocumentSnapshot(String code, Map data) {
    return StudentInAttendance(
        idNum: code,
        fullname: data['fullname'] ?? '',
        dept: data['dept'] ?? '',
        timeAndDate: (data['timeAndDate'] as Timestamp).toString(),
        isLate: data['isLate']);
  }

  Map<String, Object> toMap() {
    return {
      'idNum': idNum ?? '',
      'fullname': fullname ?? '',
      'dept': dept ?? '',
      'attendanceId': attendanceId ?? '',
      'timeAndDate': timeAndDate ?? '',
      'isLate': isLate!
    };
  }
}

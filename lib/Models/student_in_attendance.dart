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

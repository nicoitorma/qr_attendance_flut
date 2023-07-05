class StudentInAttendance {
  int? id;
  String? idNum;
  String? fullname;
  String? dept;
  int? attendanceId;
  String? timeAndDate;
  String? isLate;

  /// For Online DB
  String? code;

  StudentInAttendance(
      {this.idNum,
      this.fullname,
      this.dept,
      this.attendanceId,
      this.timeAndDate,
      this.isLate,
      this.code});

  StudentInAttendance.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        idNum = item['idNum'] ?? '',
        fullname = item['fullname'] ?? '',
        dept = item['dept'] ?? '',
        attendanceId = item['attendanceId'] ?? '',
        timeAndDate = item['timeAndDate'] ?? '',
        isLate = item['isLate'];

  factory StudentInAttendance.fromDocumentSnapshot(String idNum, Map data) {
    return StudentInAttendance(
        idNum: idNum,
        fullname: data['fullname'] ?? '',
        dept: data['dept'] ?? '',
        timeAndDate: data['timeAndDate'],
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

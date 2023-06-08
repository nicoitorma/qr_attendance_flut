class StudentInAttendance {
  int? id;
  String? idNum;
  String? fullname;
  String? dept;
  int? parentId;
  String? timeAndDate;
  bool? isLate;

  StudentInAttendance(
      {this.idNum,
      this.fullname,
      this.dept,
      this.parentId,
      this.timeAndDate,
      this.isLate});

  StudentInAttendance.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        idNum = item['idNum'] ?? '',
        fullname = item['fullname'] ?? '',
        dept = item['dept'] ?? '',
        parentId = item['parentId'] ?? '',
        timeAndDate = item['timeAndDate'] ?? '',
        isLate = item['isLate'];

  Map<String, Object> toMap() {
    return {
      'idNum': idNum ?? '',
      'fullname': fullname ?? '',
      'dept': dept ?? '',
      'parentId': parentId ?? '',
      'timeAndDate': timeAndDate ?? '',
      'isLate': isLate!
    };
  }
}

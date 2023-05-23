class StudentInAttendance {
  int? id;
  String? idNum;
  String? fullname;
  String? dept;
  int? parentId;
  String? timeAndDate;
  bool? isLate;

  StudentInAttendance(
      {this.fullname,
      this.idNum,
      this.parentId,
      this.dept,
      this.timeAndDate,
      this.isLate});
}

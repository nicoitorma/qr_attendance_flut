class QrModel {
  int? id;
  String? fullname;
  String? idNum;
  String? dept;

  QrModel({this.fullname, this.idNum, this.dept});

  QrModel.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        fullname = item['fullname'] ?? '',
        idNum = item['idNum'] ?? '',
        dept = item['dept'] ?? '';

  Map<String, Object> toMap() {
    return {
      'fullname': fullname!,
      'idNum': idNum!,
      'dept': dept ?? '',
    };
  }
}

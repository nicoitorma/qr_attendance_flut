class QrModel {
  int? id;
  String? name;
  String? idNum;
  String? college;

  QrModel({this.name, this.idNum, this.college});

  QrModel.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'] ?? '',
        idNum = item['idNum'] ?? '',
        college = item['college'] ?? '';

  Map<String, Object> toMap() {
    return {
      'name': name!,
      'idNum': idNum!,
      'college': college ?? '',
    };
  }
}

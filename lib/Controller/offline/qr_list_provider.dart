import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/qr_code.dart';
import 'package:qr_attendance_flut/Repository/qr_list_repo.dart';

class QrListProvider extends ChangeNotifier {
  List<QrModel> qrList = [];
  List<QrModel> selectedQr = [];

  getQrList() async {
    qrList = await getAllQr();
    notifyListeners();
  }

  insertQr(QrModel qrModel) async {
    await createNewQr(qrModel);
    await getQrList();
  }

  selectQr(QrModel qrModel) {
    selectedQr.add(qrModel);
    notifyListeners();
  }

  clearSelectedItems() {
    selectedQr.clear();
    notifyListeners();
  }

  removeItemFromSelected(QrModel qrModel) {
    selectedQr.remove(qrModel);
    notifyListeners();
  }

  deleteItem() async {
    for (var item in selectedQr) {
      await deleteQr(item.id!);
    }
    selectedQr.clear();
    await getQrList();
    notifyListeners();
  }

  selectAll() {
    selectedQr.clear();
    if (selectedQr.length == qrList.length) {
      return;
    } else {
      for (int i = 0; i < qrList.length; i++) {
        selectedQr.add(qrList[i]);
      }
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Models/qr_code.dart';
import 'package:qr_attendance_flut/Repository/qr_list_repo.dart';

class QrListProvider extends ChangeNotifier {
  List<QrModel> list = [];
  List<QrModel> selectedTile = [];
  bool isLongPress = false;

  setLongPress() {
    isLongPress = !isLongPress;
    notifyListeners();
  }

  getQrList() async {
    list = await getAllQr();
    notifyListeners();
  }

  insertQr(QrModel qrModel) async {
    await createNewQr(qrModel);
    await getQrList();
  }

  selectQr(QrModel qrModel) {
    selectedTile.add(qrModel);
    notifyListeners();
  }

  clearSelectedItems() {
    selectedTile.clear();
    notifyListeners();
  }

  removeItemFromSelected(QrModel qrModel) {
    selectedTile.remove(qrModel);
    notifyListeners();
  }

  deleteItem() async {
    for (var item in selectedTile) {
      await deleteQr(item.id!);
    }
    selectedTile.clear();
    await getQrList();
    notifyListeners();
  }

  selectAll() {
    selectedTile.clear();
    if (selectedTile.length == list.length) {
      return;
    } else {
      for (int i = 0; i < list.length; i++) {
        selectedTile.add(list[i]);
      }
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_content_list_repo.dart';
import 'package:qr_attendance_flut/utils/qr_saver.dart';

import '../Controller/online/online_attdnc_list_provider.dart';
import '../Models/student_in_attendance.dart';
import '../Repository/offline_repo.dart/attendance_content_repo.dart';
import '../utils/excel_writer.dart';
import '../utils/firebase_helper.dart';
import '../values/strings.dart';

class MenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic value;
  const MenuAppBar({super.key, required this.value});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(value.selectedTile.length.toString()),

      /// X button
      leading: InkWell(
          onTap: () {
            value.clearSelectedItems();
            value.setLongPress();
          },
          child: const Icon(Icons.close)),
      actions: [
        /// Delete button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                          title: Text(labelAlertDeleteTitle),
                          content: Text(labelAlertDeleteContent),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text(labelNo)),
                            TextButton(
                                onPressed: () {
                                  if (isOnlineMode()) {
                                    if (value.runtimeType ==
                                        OnlineAttendanceListProvider) {
                                      value.deleteItemOnFirestore();
                                    } else {
                                      value.deleteItemOnDocument();
                                    }
                                  } else {
                                    value.deleteItem();
                                  }
                                  value.setLongPress();
                                  Navigator.pop(context);
                                },
                                child: Text(labelYes))
                          ],
                        )));
              },
              child: const Icon(Icons.delete_outlined)),
        ),

        /// Select all button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () => value.selectAll(),
              child: const Icon(Icons.select_all_outlined)),
        ),

        /// Download button
        (value.runtimeType.toString() == 'AttendanceContentProvider' ||
                value.runtimeType.toString() == 'OnlineAttendanceContentsProv')
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () async {
                    if (value.runtimeType.toString() ==
                            'AttendanceListProvider' ||
                        value.runtimeType.toString() ==
                            'OnlineAttendanceListProvider') {
                      inAttendanceScreen(context);
                    } else if (value.runtimeType.toString() ==
                        'QrListProvider') {
                      inQrScreen(context);
                    }
                  },
                  child: const Icon(Icons.save_alt_outlined),
                ),
              )
        // : Container()
      ],
    );
  }

  inAttendanceScreen(var context) async {
    List<String> result = [];
    for (int i = 0; i < value.selectedTile.length; ++i) {
      String attendanceName = value.selectedTile[i].attendanceName;
      String details = value.selectedTile[i].details;
      List<StudentInAttendance> list = [];
      if (isOnlineMode()) {
        list = await getContentsInOnline(value.selectedTile[i].attendanceCode);
      } else {
        list = await getContentsInLocal();
      }

      result =
          await ExcelWriter.writeCustomModels(attendanceName, details, list);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
        children: [Text(result[0]), Text(result[1])],
      )));
    }
  }

  inQrScreen(var context) async {
    for (int i = 0; i < value.selectedTile.length; ++i) {
      String name = value.selectedTile[i].fullname;
      String idNum = value.selectedTile[i].idNum;
      String dept = value.selectedTile[i].dept;

      QRSaver(idNum: idNum, fullname: name, dept: dept).saveQRCodeToStorage();
    }
  }

  getContentsInOnline(code) async {
    String user = value.selectedTile[0].user;
    if (value.selectedTile[0].user == getUserEmail()) {
      return await OnlineContentListRepo().getAllContentForAdmin(code);
    } else {
      return await OnlineContentListRepo().getAllContent(user, code);
    }
    // return await OnlineAttendanceContentsProv()
    // .getAttndcContent(getUserEmail(), code);
  }

  getContentsInLocal() async {
    return await AttendanceContentRepo()
        .getAllAttendanceContent(value.selectedTile[0].id);
  }
}

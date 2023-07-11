import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Repository/online_repo.dart/online_content_list_repo.dart';

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
        (value.list.length > 1)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => value.selectAll(),
                    child: const Icon(Icons.select_all_outlined)),
              )
            : Container(),

        /// Download button
        (value.runtimeType.toString() == 'AttendanceContentProvider' ||
                value.runtimeType.toString() == 'OnlineAttendanceContentsProv')
            ? Container()
            : (value.selectedTile.length < 2)
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () async {
                        List<String> result = [];
                        String attendanceName =
                            value.selectedTile[0].attendanceName;
                        String details = value.selectedTile[0].details;
                        List<StudentInAttendance> list = [];
                        if (isOnlineMode()) {
                          list = await getContentsInOnline(
                              value.selectedTile[0].attendanceCode);
                        } else {
                          list = await getContentsInLocal();
                        }

                        result = await ExcelWriter.writeCustomModels(
                            attendanceName, details, list);

                        //ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Attendance Export'),
                                      Text(result[0])
                                    ],
                                  ),
                                  content: Text(result[1]),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          value.setLongPress();
                                          value.clearSelectedItems();
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Close')),
                                  ],
                                )));
                      },
                      child: const Icon(Icons.save_alt_outlined),
                    ),
                  )
                : Container()
      ],
    );
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_flut/Views/custom_list_tiles/base_class.dart';

import '../../values/const.dart';
import '../../values/strings.dart';

class AttendanceTile extends CustomTile {
  const AttendanceTile(
      {super.key,
      required super.data,
      required super.color,
      super.onTap,
      super.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            onTap: onTap,
            onLongPress: onLongPress,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Column(children: [
              Center(
                child: Padding(
                  padding: padding,
                  child: Text(
                    data.attendanceName,
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                ),
              ),
            ]),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      /// Details
                      Align(
                          alignment: Alignment.topLeft,
                          child: data.details == ''
                              ? const SizedBox.shrink()
                              : Text(
                                  '$labelDetails: ${data.details}',
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitleStyle,
                                )),

                      /// Attendance creation time
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: padding,
                          child: Text(
                            '$labelCreated${DateFormat(labelDateFormat).format(data.date)} ${DateFormat(labelTimeFormat).format(data.time)}',
                            overflow: TextOverflow.visible,
                            style: subtitleStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: data.cutoffTimeAndDate == 'null'
                            ? const Text('')
                            : Text(
                                '$labelCutoff${data.cutoffTimeAndDate}',
                                style: subtitleStyle,
                              ),
                      )),
                ),
              ],
            )),
      ),
    );
  }
}

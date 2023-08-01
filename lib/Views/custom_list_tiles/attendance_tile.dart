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
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Column(children: [
                Center(
                  child: Text(
                    data.attendanceName,
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                ),
                (data.attendanceCode != null)
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            '$labelAttendanceCode${data.attendanceCode}',
                            style: subtitleStyle),
                      )
                    : Container(),
                const Divider(thickness: 2),

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
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: padding,
                          child: (data.date == null)
                              ? Text(
                                  '$labelCreated${DateFormat(labelFullDtFormat).format(data.timeAndDate)}',
                                  style: subtitleStyle)
                              : Text(
                                  '$labelCreated${DateFormat(labelDateFormat).format(data.date)} ${DateFormat(labelTimeFormat).format(data.time)}',
                                  overflow: TextOverflow.visible,
                                  style: subtitleStyle,
                                ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: data.cutoffTimeAndDate == 'null'
                                ? const Text('')
                                : Text(
                                    '$labelCutoff${data.cutoffTimeAndDate}',
                                    style: subtitleStyle,
                                  ),
                          )),
                    ),
                  ],
                ),
              ])),
        ));
  }
}

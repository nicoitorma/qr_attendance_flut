import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget customCard({required var icon, required String title}) => Container(
    padding: const EdgeInsets.all(5),
    height: 150,
    width: 150,
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 80),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16))
      ],
    ));

/// The function returns a custom attendance item widget with a name, details, time, and cutoff
/// displayed in a container with a blue background and rounded corners.
///
/// Args:
///   name: The name of the attendance item.
///   details: The details parameter is a variable that contains additional information or description
/// about the attendance item.
///   time: The time parameter is a variable that holds the time information for the attendance item. It
/// is displayed as a Text widget in the customAttendanceItem widget.
///   cutoff: The cutoff parameter is likely referring to a deadline or a specific time by which
/// something needs to be completed or submitted. It is displayed as a text in the custom attendance
/// item widget.
Widget customListItem(
    {required Color color,
    var data,
    int count = 0,
    Function()? onTap,
    Function()? onLongPress}) {
  var padding = const EdgeInsets.fromLTRB(0.0, 8.0, 0, 5.0);
  bool isAttendance = (data.runtimeType.toString() == attendanceModelRuntime);
  TextStyle titleStyle = const TextStyle(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle subtitleStyle = const TextStyle(fontSize: 16, color: Colors.black);

  /// this will return a Card
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            children: [
              /// this is the TITLE in bold and the underline below
              Center(
                child: Padding(
                    padding: padding,
                    child: (isAttendance)
                        ? Text(
                            data.attendanceName,
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          )
                        : Text(
                            data.fullname,
                            textAlign: TextAlign.center,
                            style: titleStyle,
                          )),
              ),
              const Divider(thickness: 2),
            ],
          ),

          /// this is where the SUBTITLE begin, below the underline
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: padding,
                        child: (isAttendance)
                            ? Text(
                                '$labelDetails: ${data.details}',
                                overflow: TextOverflow.ellipsis,
                                style: subtitleStyle,
                              )
                            : Text(
                                data.idNum,
                                overflow: TextOverflow.ellipsis,
                                style: subtitleStyle,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0, 0),
                        child: (isAttendance)

                            /// if it is an attendance it will show the timeAndDate the
                            /// attendance is created.
                            ? Text(
                                '$labelCreated${data.date} ${data.time}',
                                overflow: TextOverflow.visible,
                                style: subtitleStyle,
                              )

                            /// otherwise it is a QR model, then it will show the department
                            : Text(
                                data.dept,
                                overflow: TextOverflow.ellipsis,
                                style: subtitleStyle,
                              ),
                      ),
                    ),
                    (data.runtimeType.toString() == studentInAttendanceRuntime)
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0),
                                child:

                                    /// it will show the timeAndDate the
                                    /// qr is scanned for the attdnc content.
                                    Text(
                                  data.timeAndDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitleStyle,
                                )),
                          )
                        : Container()
                  ],
                ),
              ),
              Expanded(
                child: (isAttendance)
                    ? Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: padding,
                              child: Text(
                                '$labelQrContents$count',
                                style: subtitleStyle,
                              ),
                            ),
                          ),
                          (data.cutoff == '')
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: padding,
                                    child: Text(
                                        '$labelCutoffDT${data.cutoff.toString()}',
                                        style: subtitleStyle),
                                  ),
                                ),
                        ],
                      )
                    : QrImageView(
                        data: '${data.fullname}&${data.idNum}&${data.dept}',
                        size: 60,
                        padding: EdgeInsets.zero,
                      ),
              )
            ],
          )),
    ),
  );
}

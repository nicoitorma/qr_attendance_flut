import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../values/const.dart';
import '../../values/strings.dart';
import 'base_class.dart';

class AttendanceContentTile extends CustomTile {
  const AttendanceContentTile(
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
            title: Column(
              children: [
                /// this is the TITLE in bold and the underline below
                Center(
                  child: Padding(
                      padding: padding,
                      child: Text(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Column(
                    children: [
                      /// ID number
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$labelIdNum: ${data.idNum}',
                          overflow: TextOverflow.ellipsis,
                          style: subtitleStyle,
                        ),
                      ),

                      /// Department
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: padding,
                          child: Text(
                            '$labelDept: ${data.dept}',
                            overflow: TextOverflow.ellipsis,
                            style: subtitleStyle,
                          ),
                        ),
                      ),

                      /// The time the QR Code is scanned
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0),
                            child:

                                /// it will show the
                                /// qr is scanned for the attdnc content.
                                Text(
                              '$labelQrScanned${data.timeAndDate}',
                              style: subtitleStyle,
                            )),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: QrImageView(
                      data: '${data.idNum}&${data.fullname}&${data.dept}',
                      size: 60,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

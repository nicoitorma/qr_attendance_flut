import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/Views/custom_list_tiles/base_class.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../values/const.dart';

class QrTile extends CustomTile {
  const QrTile(
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
                  width: MediaQuery.of(context).size.width * .5,
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
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: padding,
                      child: QrImageView(
                        data: '${data.idNum}&${data.fullname}&${data.dept}',
                        size: 60,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

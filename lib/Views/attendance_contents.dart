import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Views/custom_list_tiles/attdnc_cntnt_tile.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Controller/offline/atdnc_content_provider.dart';
import '../Models/attendance.dart';
import '../utils/qr_scanner.dart';
import '../values/const.dart';

class AttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const AttendanceContents({super.key, required this.data});

  @override
  State<AttendanceContents> createState() => _AttendanceContentsState();
}

class _AttendanceContentsState extends State<AttendanceContents> {
  TextStyle appBarSubtitleStyle = const TextStyle(fontSize: 16);
  @override
  void initState() {
    /// This code is using the `Provider` package to get an instance of the `AttendanceContentProvider`
    /// class and calling its `getAtndContent` method with the `id` property of the `widget.data` object
    /// as an argument. This is likely used to fetch the attendance content data for the given `id` and
    /// update the state of the widget accordingly. The `listen: false` parameter is used to prevent the
    /// widget from rebuilding when the provider's state changes.
    final provider =
        Provider.of<AttendanceContentProvider>(context, listen: false);
    provider.getAtndContent(widget.data.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceContentProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: (value.isLongPress)
            ? MenuAppBar(value: value)
            : AppBar(
                title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.attendanceName!),
                  (widget.data.cutoffTimeAndDate == 'null')
                      ? Container()
                      : Text('$labelCutoff${widget.data.cutoffTimeAndDate} ',
                          style: appBarSubtitleStyle)
                ],
              )),

        /// This code block is creating a floating action button with an icon of a QR code scanner. When
        /// the button is pressed, it checks if the `isLongPress` variable is true, and if so, it sets it
        /// to false and clears any selected items. It then navigates to a new page using the
        /// `Navigator.of(context).push` method, passing in a `QrScanner` widget with the `data` property
        /// set to `widget.data`. The `PageTransition` widget is used to specify the type of transition
        /// animation to use when navigating to the new page.
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (value.isLongPress) {
              value.setLongPress();
              value.clearSelectedItems();
            }
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.fade,
                child: QrScanner(data: widget.data),
                duration: transitionDuration,
                reverseDuration: transitionDuration,
                childCurrent: widget));
          },
          child: const Icon(Icons.qr_code_scanner_outlined),
        ),
        body: (value.list.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                itemCount: value.list.length,
                itemBuilder: (context, index) {
                  List selectedItem = value.selectedTile;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: AttendanceContentTile(
                        color: (selectedItem.contains(value.list[index]))
                            ? Colors.red
                            : Colors.transparent,
                        data: value.list[index],
                        onTap: () {
                          if (value.isLongPress) {
                            if (value.selectedTile
                                .contains(value.list[index])) {
                              value.removeItemFromSelected(value.list[index]);
                              if (value.selectedTile.isEmpty) {
                                value.setLongPress();
                              }
                            } else {
                              value.selectTile(value.list[index]);
                            }
                            return;
                          }
                        },
                        onLongPress: () {
                          value.setLongPress();
                          value.selectTile(value.list[index]);
                        }),
                  );
                }),
      ),
    );
  }
}

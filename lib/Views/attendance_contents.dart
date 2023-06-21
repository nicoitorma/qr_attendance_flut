import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Models/attendance.dart';
import '../utils/qr_scanner.dart';
import '../values/const.dart';
import 'instantiable_widget.dart';

class AttendanceContents extends StatefulWidget {
  final AttendanceModel data;
  const AttendanceContents({super.key, required this.data});

  @override
  State<AttendanceContents> createState() => _AttendanceContentsState();
}

class _AttendanceContentsState extends State<AttendanceContents> {
  bool isLongPress = false;
  TextStyle appBarSubtitleStyle = const TextStyle(fontSize: 16);
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AttendanceContentProvider>(context, listen: false);
    provider.getAtndContent();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceContentProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: (isLongPress)
            ? AppBar(
                title: Text(value.content.length.toString()),
                leading: InkWell(
                    onTap: () {
                      value.clearSelectedItems();
                      isLongPress = !isLongPress;
                    },
                    child: const Icon(Icons.close)),
                actions: [
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
                                            value.deleteItem();
                                            isLongPress = !isLongPress;
                                            Navigator.pop(context);
                                          },
                                          child: Text(labelYes))
                                    ],
                                  )));
                        },
                        child: const Icon(Icons.delete_outlined)),
                  ),
                  (value.content.length > 1)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => value.selectAll(),
                              child: const Icon(Icons.select_all_outlined)),
                        )
                      : Container(),
                ],
              )
            : AppBar(
                title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.attendanceName!),
                  (widget.data.cutoff == null)
                      ? Container()
                      : Text('$labelCutoffDT${widget.data.cutoff.toString()}',
                          style: appBarSubtitleStyle)
                ],
              )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isLongPress) {
              isLongPress = !isLongPress;
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
        body: (value.content.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                itemCount: value.content.length,
                itemBuilder: (context, index) {
                  List selectedItem = value.selectedTile;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: customListItem(
                        color: (selectedItem.contains(value.content[index]))
                            ? Colors.red
                            : Colors.transparent,
                        data: value.content[index],
                        onTap: () {
                          if (isLongPress) {
                            if (value.selectedTile
                                .contains(value.content[index])) {
                              value
                                  .removeItemFromSelected(value.content[index]);
                              if (value.selectedTile.isEmpty) {
                                isLongPress = !isLongPress;
                              }
                            } else {
                              value.selectTile(value.content[index]);
                            }
                            return;
                          }
                        },
                        onLongPress: () {
                          isLongPress = !isLongPress;
                          value.selectTile(value.content[index]);
                        }),
                  );
                }),
      ),
    );
  }
}

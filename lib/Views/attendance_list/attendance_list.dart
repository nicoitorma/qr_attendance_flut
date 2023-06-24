import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:qr_attendance_flut/Views/attendance_list/widgets.dart';
import 'package:qr_attendance_flut/values/const.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Controller/offline/atdnc_list_provider.dart';
import '../attendance_contents.dart';
import '../instantiable_widget.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime? selectedCutoffDateTime;
  bool isLongPress = false;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final dbContent =
        Provider.of<AttendanceListProvider>(context, listen: false);
    dbContent.getAttendanceListForDay(_focusedDay);
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceListProvider>(
        builder: (context, attendanceProv, child) => Scaffold(
              appBar: (isLongPress)
                  ? AppBar(
                      title: Text(
                          attendanceProv.clickedAttendance.length.toString()),
                      leading: InkWell(
                          onTap: () {
                            attendanceProv.clearSelectedItems();
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
                                          content:
                                              Text(labelAlertDeleteContent),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text(labelNo)),
                                            TextButton(
                                                onPressed: () {
                                                  attendanceProv.deleteItem();
                                                  isLongPress = !isLongPress;
                                                  Navigator.pop(context);
                                                },
                                                child: Text(labelYes))
                                          ],
                                        )));
                              },
                              child: const Icon(Icons.delete_outlined)),
                        ),
                        (attendanceProv.attendanceList.length > 1)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () => attendanceProv.selectAll(),
                                    child:
                                        const Icon(Icons.select_all_outlined)),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => attendanceProv.selectAll(),
                              child: const Icon(Icons.save_outlined)),
                        ),
                      ],
                    )
                  : AppBar(title: Text(labelAttendanceList)),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showPopup(attendanceProv);
                  },
                  child: const Icon(Icons.add)),
              body: Column(children: [
                TableCalendar(
                  firstDay: DateTime(2022, 10, 19),
                  lastDay: DateTime(2030, 10, 19),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        attendanceProv.getAttendanceListForDay(selectedDay);
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const Divider(thickness: 3),
                Expanded(
                  child: (attendanceProv.attendanceList.isEmpty)
                      ? Center(
                          child: Text(labelNoItem),
                        )
                      : ListView.builder(
                          itemCount: attendanceProv.attendanceList.length,
                          itemBuilder: ((context, index) {
                            List clickedAttendance =
                                attendanceProv.clickedAttendance;
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: customListItem(
                                color: (clickedAttendance.contains(
                                        attendanceProv.attendanceList[index]))
                                    ? Colors.red
                                    : Colors.transparent,
                                data: attendanceProv.attendanceList[index],
                                onTap: () {
                                  if (isLongPress) {
                                    if (clickedAttendance.contains(
                                        attendanceProv.attendanceList[index])) {
                                      attendanceProv.removeItemFromSelected(
                                          attendanceProv.attendanceList[index]);
                                      if (clickedAttendance.isEmpty) {
                                        isLongPress = !isLongPress;
                                      }
                                    } else {
                                      attendanceProv.selectAttendance(
                                          attendanceProv.attendanceList[index]);
                                    }
                                    return;
                                  }
                                  Navigator.of(context).push(PageTransition(
                                      type:
                                          PageTransitionType.rightToLeftJoined,
                                      child: AttendanceContents(
                                          data: attendanceProv
                                              .attendanceList[index]),
                                      duration: transitionDuration,
                                      reverseDuration: transitionDuration,
                                      childCurrent: widget));
                                },
                                onLongPress: () {
                                  isLongPress = !isLongPress;
                                  attendanceProv.selectAttendance(
                                      attendanceProv.attendanceList[index]);
                                },
                              ),
                            );
                          })),
                ),
              ]),
            ));
  }

  showPopup(var provider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(labelNewAttendance),
            content: SizedBox(
                width: double.maxFinite,
                child: AttendancePopup(provider: provider)),
          );
        });
  }
}

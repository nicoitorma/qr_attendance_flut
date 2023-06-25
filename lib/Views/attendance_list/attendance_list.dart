import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:qr_attendance_flut/Views/attendance_list/widgets.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Controller/offline/atdnc_list_provider.dart';
import '../../values/const.dart';
import '../attendance_contents.dart';
import '../custom_list_tiles/attendance_tile.dart';
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
              appBar: (attendanceProv.isLongPress)
                  ? MenuAppBar(value: attendanceProv)
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
                  child: (attendanceProv.list.isEmpty)
                      ? Center(
                          child: Text(labelNoItem),
                        )
                      : ListView.builder(
                          itemCount: attendanceProv.list.length,
                          itemBuilder: ((context, index) {
                            List clickedAttendance =
                                attendanceProv.selectedTile;
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AttendanceTile(
                                data: attendanceProv.list[index],
                                color: clickedAttendance
                                        .contains(attendanceProv.list[index])
                                    ? Colors.red
                                    : Colors.transparent,
                                onTap: () {
                                  if (attendanceProv.isLongPress) {
                                    if (clickedAttendance
                                        .contains(attendanceProv.list[index])) {
                                      attendanceProv.removeItemFromSelected(
                                          attendanceProv.list[index]);
                                      if (clickedAttendance.isEmpty) {
                                        attendanceProv.setLongPress();
                                      }
                                    } else {
                                      attendanceProv.selectAttendance(
                                          attendanceProv.list[index]);
                                    }
                                    return;
                                  }
                                  Navigator.of(context).push(PageTransition(
                                      type:
                                          PageTransitionType.rightToLeftJoined,
                                      child: AttendanceContents(
                                          data: attendanceProv.list[index]),
                                      duration: transitionDuration,
                                      reverseDuration: transitionDuration,
                                      childCurrent: widget));
                                },
                                onLongPress: () {
                                  attendanceProv.setLongPress();
                                  attendanceProv.selectAttendance(
                                      attendanceProv.list[index]);
                                },
                              ),
                            );
                          })),
                ),
              ]),
            ));
  }

  /// The function shows a popup dialog with a title and content that includes an attendance popup
  /// widget.
  ///
  /// Args:
  ///   provider: The "provider" parameter is being passed to the "AttendancePopup" widget as an
  /// argument. It is likely being used to provide data or functionality to the popup widget. Without
  /// more context, it is difficult to determine the exact purpose of the "provider" parameter.
  ///
  /// Returns:
  ///   The function `showPopup` is returning an `AlertDialog` widget that displays a title and a
  /// `SizedBox` containing an `AttendancePopup` widget. The `showDialog` function is used to display the
  /// `AlertDialog` widget.
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

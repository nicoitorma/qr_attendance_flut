import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_content_provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_list_provider.dart';
import 'package:qr_attendance_flut/values/const.dart';
import 'package:qr_attendance_flut/values/strings.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Models/attendance.dart';
import 'attendance_contents.dart';
import 'instantiable_widget.dart';

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
    return Consumer2<AttendanceListProvider, AttendanceContentProvider>(
        builder: (context, attendanceProv, contentProv, child) => Scaffold(
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
              body:
                  // (attendanceProv.attendanceList.isEmpty)
                  //     ? Center(child: Text(labelNoItem))
                  // :
                  Column(children: [
                TableCalendar(
                  firstDay: DateTime(2022, 10, 19),
                  lastDay: DateTime(2030, 10, 19),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: attendanceProv
                      .getAttendanceListForDay(_selectedDay ?? _focusedDay),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
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
                Expanded(
                  child: ListView.builder(
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
                            count: contentProv.content.length,
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
                                  type: PageTransitionType.rightToLeftJoined,
                                  child: AttendanceContents(
                                      data:
                                          attendanceProv.attendanceList[index]),
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

  void _submitForm(var provider) {
    if (formKey.currentState!.validate()) {
      // Form is valid, process the data
      String name = nameController.text;
      String? details = detailsController.text;
      String? cutOffDateTime =
          DateFormat(labelDateFormat).format(selectedCutoffDateTime!);

      // Perform actions with the form data
      provider.insertNewAttendance(AttendanceModel(
          attendanceName: name, details: details, cutoff: cutOffDateTime));

      // Clear the form fields
      nameController.clear();
      detailsController.clear();
      setState(() {
        selectedCutoffDateTime = null;
      });
      Navigator.of(context).pop();
    }
  }

  showPopup(var provider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(labelNewAttendance),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      inputField(
                          controller: nameController,
                          label: labelAttendanceName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return labelAttendanceName + labelEmptyFieldError;
                            }
                            return null;
                          }),
                      inputField(
                          controller: detailsController, label: labelDetails),
                      const SizedBox(height: 16.0),
                      Text(
                        labelCutoffDT +
                            (selectedCutoffDateTime == null
                                ? labelNotSet
                                : DateFormat(labelDateFormat)
                                    .format(selectedCutoffDateTime!)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((selectedTime) {
                                if (selectedTime != null) {
                                  setState(() {
                                    selectedCutoffDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: const Text('Select Cut Off Date and Time'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => _submitForm(provider),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

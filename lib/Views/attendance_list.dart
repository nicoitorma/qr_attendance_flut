import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_list_provider.dart';
import 'package:qr_attendance_flut/Views/attendance_contents.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Models/attendance.dart';

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
  final Duration duration = const Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    final dbContent =
        Provider.of<AttendanceListProvider>(context, listen: false);
    dbContent.getAttendanceList();
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
      builder: (context, value, child) => Scaffold(
        appBar: (isLongPress)
            ? AppBar(
                title: Text(value.clickedAttendance.length.toString()),
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
                        onTap: () => value.selectAll(),
                        child: const Icon(Icons.select_all_outlined)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          value.deleteItem();
                          isLongPress = !isLongPress;
                        },
                        child: const Icon(Icons.delete_outlined)),
                  )
                ],
              )
            : AppBar(title: Text(labelAttendanceList)),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showPopup(value);
            },
            child: const Icon(Icons.add)),
        body: (value.attendanceList.isEmpty)
            ? const Center(child: Text('NO ITEM'))
            : ListView.builder(
                itemCount: value.attendanceList.length,
                itemBuilder: ((context, index) {
                  List clickedAttendance = value.clickedAttendance;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: customAttendanceItem(
                      color: (clickedAttendance
                              .contains(value.attendanceList[index]))
                          ? Colors.red
                          : Colors.transparent,
                      attendanceData: value.attendanceList[index],
                      onTap: () {
                        if (isLongPress) {
                          if (value.clickedAttendance
                              .contains(value.attendanceList[index])) {
                            value.removeItem(value.attendanceList[index]);
                            if (value.clickedAttendance.isEmpty) {
                              isLongPress = !isLongPress;
                            }
                          } else {
                            value.selectAttendance(value.attendanceList[index]);
                          }
                          return;
                        }
                        Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.rightToLeftJoined,
                            child: AttendanceContents(
                                data: value.attendanceList[index]),
                            duration: duration,
                            reverseDuration: duration,
                            childCurrent: widget));
                      },
                      onLongPress: () {
                        isLongPress = !isLongPress;
                        value.selectAttendance(value.attendanceList[index]);
                      },
                    ),
                  );
                })),
      ),
    );
  }

  void _submitForm(var provider) {
    if (formKey.currentState!.validate()) {
      // Form is valid, process the data
      String name = nameController.text;
      String? details = detailsController.text;
      String? cutOffDateTime;
      if (selectedCutoffDateTime != null) {
        cutOffDateTime =
            DateFormat('MM/dd/yyyy, hh:mm a').format(selectedCutoffDateTime!);
      }

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
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return labelAttendanceName + emptyFieldError;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: labelAttendanceName,
                        ),
                      ),
                      TextFormField(
                        controller: detailsController,
                        decoration: InputDecoration(
                          labelText: details,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        cutoffDT +
                            (selectedCutoffDateTime != null
                                ? DateFormat('MM/dd/yyyy, hh:mm a')
                                    .format(selectedCutoffDateTime!)
                                : "Not set"),
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

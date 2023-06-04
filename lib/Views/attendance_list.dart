import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/attendance_list_controller.dart';
import 'package:qr_attendance_flut/Views/instantiable_widget.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Models/attendance.dart';
import '../Repository/attendance_list_repository.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime? selectedDateTime;
  bool isLongPress = false;

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceListProvider>(
      builder: (context, attendanceListProvider, child) => Scaffold(
        appBar: AppBar(title: Text(labelAttendanceList)),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showPopup();
              attendanceListProvider.getAttendanceList();
            },
            child: const Icon(Icons.add)),
        body: ListView.builder(
            itemCount: attendanceListProvider.attendanceList.length,
            itemBuilder: ((context, index) {
              return customAttendanceItem(
                  name: attendanceListProvider
                      .attendanceList[index].attendanceName!,
                  detail: attendanceListProvider.attendanceList[index].details,
                  time: attendanceListProvider.attendanceList[index].dateTime);
            })),
      ),
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      // Form is valid, process the data
      String name = nameController.text;
      String? details = detailsController.text;
      String? cutOffDateTime;
      if (selectedDateTime != null) {
        cutOffDateTime =
            DateFormat('MM/dd/yyyy, hh:mm a').format(selectedDateTime!);
      }

      // Perform actions with the form data
      newAttendance(AttendanceModel(
          attendanceName: name,
          details: details,
          dateTime: DateFormat('MM/dd/yyyy, hh:mm a')
              .format(DateTime.now())
              .toString(),
          cutoff: cutOffDateTime.toString()));

      // Clear the form fields
      nameController.clear();
      detailsController.clear();
      setState(() {
        selectedDateTime = null;
      });
      Navigator.of(context).pop();
    }
  }

  showPopup() {
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
                            return attendanceName + emptyFieldError;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: attendanceName,
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
                            (selectedDateTime != null
                                ? DateFormat('MM/dd/yyyy, hh:mm a')
                                    .format(selectedDateTime!)
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
                                    selectedDateTime = DateTime(
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
                        onPressed: _submitForm,
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

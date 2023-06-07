import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance_flut/Controller/atdnc_list_provider.dart';
import 'package:qr_attendance_flut/Views/attendance_contents.dart';
import 'package:qr_attendance_flut/values/const.dart';
import 'package:qr_attendance_flut/values/strings.dart';

import '../Models/attendance.dart';
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
                        onTap: () {
                          value.deleteItem();
                          isLongPress = !isLongPress;
                        },
                        child: const Icon(Icons.delete_outlined)),
                  ),
                  (value.attendanceList.length > 1)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => value.selectAll(),
                              child: const Icon(Icons.select_all_outlined)),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () => value.selectAll(),
                        child: const Icon(Icons.save_outlined)),
                  ),
                ],
              )
            : AppBar(title: Text(labelAttendanceList)),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showPopup(value);
            },
            child: const Icon(Icons.add)),
        body: (value.attendanceList.isEmpty)
            ? Center(child: Text(labelNoItem))
            : ListView.builder(
                itemCount: value.attendanceList.length,
                itemBuilder: ((context, index) {
                  List clickedAttendance = value.clickedAttendance;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: customListItem(
                      color: (clickedAttendance
                              .contains(value.attendanceList[index]))
                          ? Colors.red
                          : Colors.transparent,
                      data: value.attendanceList[index],
                      onTap: () {
                        if (isLongPress) {
                          if (value.clickedAttendance
                              .contains(value.attendanceList[index])) {
                            value.removeItemFromSelected(
                                value.attendanceList[index]);
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
                            duration: transitionDuration,
                            reverseDuration: transitionDuration,
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
            DateFormat(labelDateFormat).format(selectedCutoffDateTime!);
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
                            (selectedCutoffDateTime != null
                                ? DateFormat(labelDateFormat)
                                    .format(selectedCutoffDateTime!)
                                : labelNotSet),
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

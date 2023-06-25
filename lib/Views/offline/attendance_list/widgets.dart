import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Controller/offline/atdnc_list_provider.dart';
import '../../../Models/attendance.dart';
import '../../../values/const.dart';
import '../../../values/strings.dart';

class AttendancePopup extends StatefulWidget {
  final AttendanceListProvider provider;

  const AttendancePopup({Key? key, required this.provider}) : super(key: key);

  @override
  State<AttendancePopup> createState() => _AttendancePopupState();
}

class _AttendancePopupState extends State<AttendancePopup> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime? cutoffTimeAndDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            inputField(controller: detailsController, label: labelDetails),
            const SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(labelCutoff),
              cutoffTimeAndDate == null
                  ? Text(labelNotSet)
                  : Text(
                      DateFormat(labelFullDtFormat).format(cutoffTimeAndDate!)),
            ]),
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
                          cutoffTimeAndDate = DateTime(
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
              child: Text(labelSelectCutoffDt),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              // => _submitForm(),
              child: Text(labelSubmit),
            ),
          ],
        ),
      ),
    );
  }

  /// This function processes and inserts new attendance data into a provider, clears form fields, and
  /// closes the form.
  void _submitForm() {
    if (formKey.currentState!.validate()) {
      // Form is valid, process the data
      String name = nameController.text;
      String? details = detailsController.text;

      // Perform actions with the form data
      widget.provider.insertNewAttendance(AttendanceModel(
          attendanceName: name,
          details: details,
          cutoffTimeAndDate: (cutoffTimeAndDate == null)
              ? 'null'
              : DateFormat(labelFullDtFormat).format(cutoffTimeAndDate!)));

      // Clear the form fields
      nameController.clear();
      detailsController.clear();
      setState(() {
        cutoffTimeAndDate = null;
      });
      Navigator.of(context).pop();
    }
  }
}

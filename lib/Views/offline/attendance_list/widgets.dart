import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance_flut/Controller/online/online_attdnc_list_provider.dart';
import 'package:qr_attendance_flut/utils/firebase_helper.dart';

import '../../../Controller/offline/atdnc_list_provider.dart';
import '../../../Models/attendance.dart';
import '../../../values/const.dart';
import '../../../values/strings.dart';

class CreateAttendancePopup extends StatefulWidget {
  final AttendanceListProvider? provider;

  const CreateAttendancePopup({Key? key, this.provider}) : super(key: key);

  @override
  State<CreateAttendancePopup> createState() => _CreateAttendancePopupState();
}

class _CreateAttendancePopupState extends State<CreateAttendancePopup> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime? cutoffTimeAndDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(labelCreateAttendance),
          leadingWidth: 30,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => _submitForm(),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  child: Text(labelSubmit)),
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                const SizedBox(height: 10.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(labelCutoff),
                        cutoffTimeAndDate == null
                            ? Text(labelNotSet)
                            : Text(DateFormat(labelFullDtFormat)
                                .format(cutoffTimeAndDate!)),
                      ]),
                ),
                const SizedBox(height: 5.0),
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
              ],
            ),
          ),
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

      if (isOnlineMode()) {
        OnlineAttendanceListProvider().createAttendance(AttendanceModel(
            attendanceName: name,
            details: details,
            cutoffTimeAndDate: (cutoffTimeAndDate == null)
                ? 'null'
                : DateFormat(labelFullDtFormat).format(cutoffTimeAndDate!)));
      } else {
        /// This code is calling the `insertNewAttendance` method of the `provider` object passed to the
        /// `AttendancePopup` widget as a parameter. It is passing a new `AttendanceModel` object as an
        /// argument, which is created using the values entered in the form fields and the `cutoffTimeAndDate`
        /// variable. If `cutoffTimeAndDate` is null, it passes the string "null" as the value for the
        /// `cutoffTimeAndDate` field of the `AttendanceModel`.
        widget.provider?.insertNewAttendance(AttendanceModel(
            attendanceName: name,
            details: details,
            cutoffTimeAndDate: (cutoffTimeAndDate == null)
                ? 'null'
                : DateFormat(labelFullDtFormat).format(cutoffTimeAndDate!)));
      }

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

// tableCalendar({
//   DateTime? focusedDay,
//   CalendarFormat calendarFormat = CalendarFormat.month,
//   DateTime? selectedDay,
//   Function(DateTime?, DateTime?)? onDaySelected,
//   Function(CalendarFormat)? onFormatChanged,
// }) =>
//     TableCalendar(
//       firstDay: DateTime(2022, 10, 19),
//       lastDay: DateTime(2030, 10, 19),
//       focusedDay: focusedDay ?? DateTime.now(),
//       selectedDayPredicate: (day) => isSameDay(selectedDay, day),
//       calendarFormat: calendarFormat,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       calendarStyle: const CalendarStyle(
//         outsideDaysVisible: false,
//       ),
//       onDaySelected: onDaySelected,
//       onFormatChanged: onFormatChanged,
//       onPageChanged: (focusedDay) {
//         focusedDay = focusedDay;
//       },
//     );

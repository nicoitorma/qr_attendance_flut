import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/const.dart';

import '../values/strings.dart';

class JoinAttendance extends StatelessWidget {
  const JoinAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController codeController = TextEditingController();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(labelJoinAttendance),
            leadingWidth: 30,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () => _submitForm(),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green)),
                    child: Text(labelJoin)),
              ),
            ],
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin1),
                ),
                inputField(
                    controller: codeController, label: 'Attendance Code'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin2),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(msgJoin4),
                ),
              ]),
            ),
          )),
    );
  }

  void _submitForm() {}
}

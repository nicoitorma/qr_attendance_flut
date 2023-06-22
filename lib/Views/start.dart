import 'package:flutter/material.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 80),
              child: Text(
                labelWelcome,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: InkWell(
                onTap: () => _showModalBottom(
                    context, labelOnlineMode, msgOnlineAttendance, msgQr),
                child: Card(
                    elevation: 10,
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        labelOnlineMode,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: InkWell(
                onTap: () => _showModalBottom(
                    context, labelOfflineMode, msgOfflineAttendance, msgQr),
                child: Card(
                    elevation: 10,
                    color: Colors.blue[400],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        labelOfflineMode,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showModalBottom(var context, String title, String msg1, String msg2) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(labelOnAttendance,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(msg1),
                  Text(labelQrCodes,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(msg2),
                  Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            title == labelOnlineMode
                                ? Navigator.pushReplacementNamed(
                                    context, '/sign-in')
                                : Navigator.pushReplacementNamed(
                                    context, '/homepage');
                          },
                          child: Text(
                            labelProceed,
                            style: const TextStyle(fontSize: 18),
                          )))
                ],
              ),
            ));
  }
}

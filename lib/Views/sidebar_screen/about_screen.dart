import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:qr_attendance_flut/values/strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(labelAbout)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const HtmlWidget(
              '''
          <h2>Welcome to QR Attendance!</h2>
          <p> 
          QR Attendance is a powerful and intuitive mobile application designed to revolutionize the way organizations track attendance. Our app harnesses the convenience and efficiency of QR codes to streamline attendance management processes, making them effortless and accurate.
        With QR Attendance, you can bid farewell to tedious manual attendance tracking methods and embrace the future of attendance management. Whether you're an educational institution, a corporate entity, or an event organizer, our app caters to your specific needs, enabling you to save time and resources while enhancing overall efficiency.</p>
          <h3>Key Features:</h3>
          <p>1. QR Code Generation: Generate unique QR codes for individuals or events in a matter of seconds. These codes can be printed or displayed digitally for participants to scan effortlessly.</p>
          <p>2. Quick Check-In: Participants can simply scan the QR codes using their smartphones, instantly marking their attendance. No need for paper-based sign-in sheets or time-consuming manual entry.</p>
          <p>3. Data Security: We prioritize the privacy and security of your data. Rest assured that attendance records are stored securely and comply with relevant data protection regulations.</p>
          <hr>
          <p>QR Attendance is designed to be user-friendly, ensuring that both organizers and participants have a seamless experience. Our intuitive interface and straightforward processes guarantee a hassle-free attendance management system that anyone can master in no time.</p>
          <hr>
          <p><b>Developed by: Nicanor Itorma</b></p>
          <p><b>Logo Designer: Shanne Mae Tindugan</b><p>
          ''',
              textStyle: TextStyle(fontSize: 15),
            ),
            Image.asset('assets/images/dev.png')
          ]),
        ),
      ),
    );
  }
}

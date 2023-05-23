import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Attendance')),
      drawer: Drawer(
        child: Column(
          children: [
            const CircleAvatar(),
            const Divider(thickness: 1, color: Colors.grey),
            GestureDetector(
              child: const Row(
                children: [Icon(Icons.help), Text('Help')],
              ),
            )
          ],
        ),
      ),
    );
  }
}

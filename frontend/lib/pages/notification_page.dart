import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF50057),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF50057),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              size: 100,
              color: Colors.white30,
            ),
            Text(
              "No notification available",
              style: TextStyle(color: Colors.white30, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
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
              Icons.account_tree_rounded,
              size: 100,
              color: Colors.white30,
            ),
            Text(
              "No tracking available",
              style: TextStyle(color: Colors.white30, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
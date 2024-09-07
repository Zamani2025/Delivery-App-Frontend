import 'package:flutter/material.dart';

class DashboardItem extends StatefulWidget {
  final String text;
  final IconData iconData;
  const DashboardItem({super.key, required this.text, required this.iconData});

  @override
  State<DashboardItem> createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 99, 2, 38),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Icon(
              widget.iconData,
              color: Colors.white,
              size: 45,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.text,
          style: const TextStyle(
              color: Color.fromARGB(255, 40, 30, 30),
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

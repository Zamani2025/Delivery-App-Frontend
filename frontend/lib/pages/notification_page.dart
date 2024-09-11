import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/service/message_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;

  Future<void> _deleteMessage(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/delete-message/$id/"),
        headers: {
          "Content-type": 'application/json',
          "Authorization": "Bearer $accessToken"
        });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
      String message = json.decode(response.body)['message'];

      MotionToast.success(
        description: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        title: const Text(
          "Success",
          style: TextStyle(color: Colors.white),
        ),
        dismissable: true,
        position: MotionToastPosition.top,
        enableAnimation: true,
        toastDuration: const Duration(seconds: 10),
        layoutOrientation: TextDirection.ltr,
        animationType: AnimationType.fromLeft,
      ).show(context);
    } else {
      setState(() {
        isLoading = false;
      });
      MotionToast.error(
        description: const Text(
          "Failed to response message",
          style: TextStyle(color: Colors.white),
        ),
        title: const Text(
          "Error",
          style: TextStyle(color: Colors.white),
        ),
        dismissable: true,
        position: MotionToastPosition.top,
        enableAnimation: true,
        toastDuration: const Duration(seconds: 10),
        layoutOrientation: TextDirection.ltr,
        animationType: AnimationType.fromLeft,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 2, 38),
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 99, 2, 38),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: FutureBuilder(
        future: messageProvider.fetchMessage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Loading....",
                    style: TextStyle(color: Colors.white),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_rounded,
                    size: 100,
                    color: Colors.white30,
                  ),
                  Text(
                    "${snapshot.error}",
                    style: const TextStyle(color: Colors.white30, fontSize: 30),
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                itemCount: messageProvider.message.length,
                itemBuilder: (context, index) {
                  final message = messageProvider.message;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 99, 2, 38),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Text(
                              message[index].message,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Positioned(
                              right: 5,
                              top: 15,
                              child: IconButton(
                                onPressed: () {
                                  _deleteMessage("${message[index].id}");
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 100,
                    color: Colors.white30,
                  ),
                  Text(
                    "No Messages available",
                    style: TextStyle(color: Colors.white30, fontSize: 30),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

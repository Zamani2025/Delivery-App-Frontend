import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/pages/landing_page.dart';
import 'package:frontend/service/message_service.dart';
import 'package:frontend/service/order_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => OrdersProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MessageProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then(
      (token) {
        print("FCM Token: $token");
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("Message received: ${message.notification?.title}");
      },
    );
  }

  void sendTokenToBackend(String token) async {
    final response = await http.post(Uri.parse("uri"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{'token': token, 'user_type': 'customer'}));
    if (response.statusCode == 200) {
      print("Token saved successfully");
    } else {
      print("Fialed to save token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

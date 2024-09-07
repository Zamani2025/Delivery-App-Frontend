import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/pages/driver_home.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/landing_page_one.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/welcome_page.dart';
import 'package:frontend/service/user_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _loadUserInfo() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var name = localstorage.getString("first_name");
    var token = localstorage.getString('access_token');
    var userType = localstorage.getString('user_type');
    bool isOpened = await hasOpenedApp();

    if (!isOpened == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LandingPageOne(),
          ),
          (route) => false);
    } else {
      if (token == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const WelcomePage(),
            ),
            (route) => false);
      } else {
        ApiResponse response = await getUserDetails();
        if (response.error == null) {
          if (userType == "driver") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DriverHome(),
                ),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false);
          }
          MotionToast.success(
            description: Text(
              "Welcome back, $name",
              style: const TextStyle(color: Colors.white),
            ),
            title: const Text(
              "Success",
              style: TextStyle(color: Colors.white),
            ),
            dismissable: true,
            position: MotionToastPosition.top,
            enableAnimation: true,
            toastDuration: const Duration(seconds: 5),
            layoutOrientation: TextDirection.ltr,
            animationType: AnimationType.fromLeft,
          ).show(context);
        } else if (response.error == "Unthorized User") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);

          MotionToast.success(
            description: Text(
              "You have been looged out",
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
          MotionToast.error(
            description: Text(
              "${response.error}",
              style: const TextStyle(color: Colors.white),
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 4), _loadUserInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF50057),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFFF50057),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/no_background_1.png"),
                        fit: BoxFit.cover)),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo_r.png"),
                        fit: BoxFit.cover)),
              )
            ],
          ),
        ));
  }
}

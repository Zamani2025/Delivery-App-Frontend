import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
// import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/pages/welcome_page.dart';

class LandingPageOne extends StatelessWidget {
  final Color kDarkBlueColor = const Color(0xFF053149);

  const LandingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Register',
      onFinish: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const RegisterPage(),
          ),
        );
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: kDarkBlueColor,
      ),
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFF50057),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFF50057),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const WelcomePage(),
          ),
        );
      },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      centerBackground: true,
      pageBackgroundColor: Colors.white,
      
      background: [
        Image.asset(
          'assets/images/undraw_1.png',
          height: 400,
        ),
        Image.asset(
          'assets/images/undraw_2.png',
          height: 350,
        ),
        Image.asset(
          'assets/images/undraw_3.png',
          height: 350,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
              ),
              Text(
                'Make your order',
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color: Color(0xFFF50057),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem epsemc dfhsed dfshd fddwsc hnhgjf fgdyf DFHER dfhreh fehre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
              ),
              Text(
                'Track your order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF50057),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem epsemc dfhsed dfshd fddwsc hnhgjf fgdyf DFHER dfhreh fehre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
              ),
              Text(
                'Start now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF50057),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem epsemc dfhsed dfshd fddwsc hnhgjf fgdyf DFHER dfhreh fehre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

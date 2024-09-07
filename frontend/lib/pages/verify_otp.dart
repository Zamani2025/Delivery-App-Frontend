import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/service/user_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  void _verifyOtp(String otp) async {
    try {
      ApiResponse apiResponse = await verifyOtp(otp);

      if (apiResponse.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 40,
              ),
              iconColor: Colors.white,
              title: const Text(
                "Success!!",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Text(
                "${apiResponse.data}",
                style: const TextStyle(color: Colors.white),
              ),
              elevation: 2.0,
              backgroundColor: const Color.fromARGB(255, 3, 152, 8),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(
                Icons.cancel,
                color: Colors.white,
                size: 40,
              ),
              title: const Text(
                "Verification failed!!",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Text(
                "${apiResponse.error}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              elevation: 2.0,
              backgroundColor: const Color.fromARGB(255, 212, 4, 4),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
              size: 40,
            ),
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
            elevation: 2.0,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 230,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/undraw_1.png"),
                            fit: BoxFit.cover)),
                  ),
                  const Text(
                    "Verification Code",
                    style: TextStyle(
                        color: Color(0xFFF50057),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                width: double.infinity,
                // height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                    color: Color(0xFFF50057),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(40))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "We texted you a code to your email, please enter it below",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OtpTextField(
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      numberOfFields: 6,
                      showFieldAsBox: true,
                      alignment: Alignment.center,
                      borderColor: Colors.white,
                      focusedBorderColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      onSubmit: (String otp) async {
                        _verifyOtp(otp);
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "This helps us verify every user in our application",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

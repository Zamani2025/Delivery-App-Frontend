import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/undraw_2.png"),
                          fit: BoxFit.cover)),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 99, 2, 38),
                borderRadius: BorderRadius.only(topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Let's get started",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Who do you wanna login as?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: const Center(
                          child: Text(
                        "Login as Customer",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 2, 38),
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: const Center(
                          child: Text(
                        "Login as Delivery",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 2, 38),
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

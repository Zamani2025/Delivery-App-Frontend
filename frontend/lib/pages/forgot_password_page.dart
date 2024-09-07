import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/undraw_1.png"),
                          fit: BoxFit.cover)),
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
                  color: Color.fromARGB(255, 99, 2, 38),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40,),
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Enter your email to recover your account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color.fromARGB(255, 99, 2, 38),
                        ),
                        filled: true,
                        hintText: "Email Address",
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 99, 2, 38)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 99, 2, 38)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 99, 2, 38)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                              color: Color.fromARGB(255, 99, 2, 38),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

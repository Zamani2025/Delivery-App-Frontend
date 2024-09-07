import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/pages/driver_home.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/service/user_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSecure = true;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _loginUser() async {
    ApiResponse response =
        await login(emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToDashboard(response.data);
    } else {
      setState(() {
        isLoading = false;
      });

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
        toastDuration: const Duration(seconds: 5),
        layoutOrientation: TextDirection.ltr,
        animationType: AnimationType.fromLeft,
      ).show(context);
    }
  }

  void _saveAndRedirectToDashboard(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("id", data['user_id'] ?? 0);
    await preferences.setString("first_name", data['first_name'] ?? "");
    await preferences.setString("last_name", data['last_name'] ?? "");
    await preferences.setString("email", data['email'] ?? "");
    await preferences.setString("user_type", data['user_type'] ?? "");

    await preferences.setBool("hasOpenedApp", true);

    var firstName = preferences.getString("first_name");
    var lastName = preferences.getString("last_name");
    var userType = preferences.getString("user_type");

    if (userType == "driver") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DriverHome()),
          (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }

    MotionToast.success(
      description: Text(
        "Welcome back, $firstName $lastName",
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Welcome Back!!!!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Sign in to start delivering",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email field is required";
                            }
                            return null;
                          },
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
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password field is required";
                            }
                            return null;
                          },
                          obscureText: isSecure,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 99, 2, 38),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSecure = !isSecure;
                                  });
                                },
                                icon: isSecure
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Color.fromARGB(255, 99, 2, 38),
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Color.fromARGB(255, 99, 2, 38),
                                      )),
                            hintStyle: const TextStyle(color: Colors.black),
                            contentPadding: const EdgeInsets.all(10),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage(),
                              )),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                                _loginUser();
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: isLoading
                                  ? const SizedBox(
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Color.fromARGB(255, 99, 2, 38),
                                      ))
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 99, 2, 38),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              )),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

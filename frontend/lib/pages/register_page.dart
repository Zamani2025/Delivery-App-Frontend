import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/verify_otp.dart';
import 'package:frontend/service/user_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSecure = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String _usertype = "customer";
  bool _availability = true;

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    vehicleNumberController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    ApiResponse response = await register(
        emailController.text,
        firstNameController.text,
        lastNameController.text,
        _usertype,
        passwordController.text,
        phoneNumberController.text,
        vehicleNumberController.text,
        _availability);
    if (response.error == null) {
      __saveAndRedirectTOtp(response.data as User);
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

  void __saveAndRedirectTOtp(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("id", user.id ?? 0);
    await preferences.setString("first_name", user.firstName ?? "");
    await preferences.setString("last_name", user.lastName ?? "");
    await preferences.setString("email", user.email ?? "");
    await preferences.setString("user_type", user.userType ?? "");

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const VerifyOtpPage()),
        (route) => false);
    var firstName = preferences.getString("first_name");
    var lastName = preferences.getString("last_name");

    MotionToast.success(
      description: Text(
        "Hi $firstName $lastName, Kindly check your email and verify the opt passcode",
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/undraw_1.png"),
                            fit: BoxFit.cover)),
                  ),
                  const Text(
                    "Register with us now!!!!",
                    style: TextStyle(
                        color: Color.fromARGB(255, 99, 2, 38),
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
                    color: Color.fromARGB(255, 99, 2, 38),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "First Name field is required";
                              }
                              return null;
                            },
                            controller: firstNameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 99, 2, 38),
                              ),
                              filled: true,
                              hintText: "First Name",
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
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Last Name field is required";
                              }
                              return null;
                            },
                            controller: lastNameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 99, 2, 38),
                              ),
                              filled: true,
                              hintText: "Last Name",
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
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email Address field is required";
                              }
                              return null;
                            },
                            controller: emailController,
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
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            hint: const Text("User Type"),
                            value: _usertype,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "User Type field is required";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.accessible,
                                  color: Color.fromARGB(255, 99, 2, 38),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 99, 2, 38),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(10),
                                filled: true),
                            items: const [
                              DropdownMenuItem(
                                value: "customer",
                                child: Text("Customer"),
                              ),
                              DropdownMenuItem(
                                value: "driver",
                                child: Text("Driver"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _usertype = value!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_usertype == "driver") ...[
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone Number field is required";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: phoneNumberController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Phone Number",
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Color.fromARGB(255, 99, 2, 38),
                                ),
                                hintStyle: TextStyle(color: Colors.black),
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
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Vehicle Number field is required";
                                }
                                return null;
                              },
                              controller: vehicleNumberController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Vehicle Number",
                                prefixIcon: Icon(
                                  Icons.car_crash_sharp,
                                  color: Color.fromARGB(255, 99, 2, 38),
                                ),
                                hintStyle: TextStyle(color: Colors.black),
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
                              height: 5,
                            ),
                            SwitchListTile(
                              title: const Text(
                                "Availability",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: _availability,
                              onChanged: (value) {
                                setState(() {
                                  _availability = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password field is required";
                              } else if (value.length <= 6) {
                                return "Password must be >= 6";
                              }
                              return null;
                            },
                            obscureText: isSecure,
                            controller: passwordController,
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
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                  _registerUser();
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
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: Colors.red,
                                        ))
                                    : const Text(
                                        "Register",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 99, 2, 38),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "ALready have an account?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                )),
                                child: const Text(
                                  "Login",
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
            ),
          ],
        ),
      ),
    );
  }
}

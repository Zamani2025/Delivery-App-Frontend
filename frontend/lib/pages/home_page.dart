import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/dashboard_item.dart';
import 'package:frontend/components/drawer_page.dart';
import 'package:frontend/pages/notification_page.dart';
import 'package:frontend/pages/orders_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _grettingMessage = "";
  var first_name;
  var email;
  var last_name;
  String pickupAddress = '';
  String delivryAddress = '';
  String packageAddress = '';
  String receiverName = '';
  String receiverPhone = '';
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  List drivers = [];
  int? selectedDriverId;

  Future<void> _createDelivery() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/order/"),
        headers: {
          "Content-type": 'application/json',
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode({
          "pickup_address": pickupAddress,
          "delivery_address": delivryAddress,
          "package_details": packageAddress,
          "receiver_name": receiverName,
          "receiver_phone": receiverPhone,
          "driver_id": selectedDriverId
        }));

    if (response.statusCode == 201) {
      setState(() {
        isLoading = true;
      });

      MotionToast.success(
        description: const Text(
          "Delivery created successfully",
          style: TextStyle(color: Colors.white),
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
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading = false;
      });
      MotionToast.error(
        description: const Text(
          "Failed to create delivery",
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

  void _setGreetingMessag() {
    DateTime now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      setState(() {
        _grettingMessage = "Good Morning";
      });
    } else if (now.hour >= 12 && now.hour < 17) {
      setState(() {
        _grettingMessage = "Good Afternoon";
      });
    } else if (now.hour >= 17 && now.hour < 21) {
      setState(() {
        _grettingMessage = "Good Evening";
      });
    } else {
      setState(() {
        _grettingMessage = "Good Night";
      });
    }
  }

  Future<List> _fetchDrivers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/drivers/"),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Fail to load");
    }
  }

  Future<void> _trackOrders() async {
    var message = "";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/track-orders/"), headers: {
      "Authorization": "Bearer $accessToken",
    }, body: {
      "order_id": _controller.text
    });

    if (response.statusCode == 200) {
      message = jsonDecode(response.body)['message'];

      setState(() {
        _controller.text = "";
      });
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

      Navigator.pop(context);
    } else {
      message = jsonDecode(response.body)['message'];

      setState(() {
        _controller.text = "";
      });
      MotionToast.error(
        description: Text(
          message,
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

      Navigator.pop(context);
    }
  }

  void _loadUserinfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      first_name = preferences.getString("first_name");
      last_name = preferences.getString("last_name");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserinfo();
    _fetchDrivers().then(
      (value) {
        setState(() {
          drivers = value;
        });
      },
    );
    _setGreetingMessag();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 2, 38),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 2, 38),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  )),
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
      ),
      drawer: DrawerPage(
        email: email,
        firstName: first_name,
        lastName: last_name,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 99, 2, 38),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, $first_name $last_name",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _grettingMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What are you looking for today?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 59, 2, 22),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 900,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Send Order",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(),
                                          Expanded(
                                              child: Form(
                                            key: _formKey,
                                            child: ListView(
                                              children: [
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a receiver name';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    receiverName = newValue!;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Receiver Name",
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    99,
                                                                    2,
                                                                    38)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a receiver phone';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    receiverPhone = newValue!;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Receiver phone",
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    99,
                                                                    2,
                                                                    38)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a pickup address';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    pickupAddress = newValue!;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "Pickup Address",
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    99,
                                                                    2,
                                                                    38)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Delivery Address';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    delivryAddress = newValue!;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        "Delivery Address",
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 99, 2, 38)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                DropdownButtonFormField(
                                                  value: selectedDriverId,
                                                  hint: const Text(
                                                      "Select a Driver"),
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 99, 2, 38)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                  items: drivers.map<
                                                      DropdownMenuItem<int>>(
                                                    (driver) {
                                                      return DropdownMenuItem(
                                                          value: driver['id'],
                                                          child: Text(driver[
                                                                  'user']
                                                              ['first_name']));
                                                    },
                                                  ).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedDriverId = value;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter package details';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    packageAddress = newValue!;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Package Details',
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    99,
                                                                    2,
                                                                    38)),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      _formKey.currentState!
                                                          .save();
                                                      _createDelivery();
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.black),
                                                    child: const Center(
                                                      child: Text(
                                                        "Create Delivery",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const DashboardItem(
                                iconData: Icons.badge,
                                text: "Send Order",
                              ),
                            ),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => Form(
                                  key: _formKey,
                                  child: AlertDialog(
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _trackOrders();
                                            }
                                          },
                                          child: const Text("Track Order")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                    ],
                                    title: const Text(
                                      "Track Your Orders",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: TextFormField.new(
                                      controller: _controller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Order ID field is required";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter order ID",
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: const DashboardItem(
                                iconData: Icons.account_tree_rounded,
                                text: "Track Order",
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const OrdersPage(),
                              )),
                              child: const DashboardItem(
                                iconData: Icons.shopping_bag,
                                text: "My Oders",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 51, 1, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 189,
                              height: 150,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Be a",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Pro Member",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "and get more additional features",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 186,
                              height: 149,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_background_2.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF50057),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 186,
                              height: 149,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_background_1.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: 189,
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Upto 50%",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      "Discount On Send Packages",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 80,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Center(
                                        child: Text(
                                          "#Deb2022",
                                          style: TextStyle(
                                              color: Color(0xFFF50057),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

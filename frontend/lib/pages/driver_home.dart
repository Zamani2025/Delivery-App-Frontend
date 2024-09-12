import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/drawer_page.dart';
import 'package:frontend/service/order_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  String _grettingMessage = "";
  var first_name;
  var email;
  var last_name;
  bool isLoading = false;

  Future<void> _changeOrderStatus(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/change-orders/$id/"),
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
          "Failed to response orders",
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

  Future<void> _rejectOrder(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/reject-orders/$id/"),
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
          "Failed to response orders",
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
    _setGreetingMessag();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 2, 38),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 2, 38),
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
            child: FutureBuilder(
              future: ordersProvider.fetchOrder(),
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
                          style: const TextStyle(
                              color: Colors.white30, fontSize: 30),
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
                      itemCount: ordersProvider.order.length,
                      itemBuilder: (context, index) {
                        final order = ordersProvider.order;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_background_2.png")),
                                color: const Color.fromARGB(255, 99, 2, 38),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Order ID ${order[index].orderId}',
                                              style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              order[index].receiverName,
                                              style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                      order[index].status == "pending"
                                          ? Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _changeOrderStatus(
                                                        "${order[index].id}");
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                      Color.fromARGB(
                                                          255, 16, 210, 6),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _rejectOrder(
                                                        "${order[index].id}");
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.white),
                                                  ),
                                                  child: const Text("Reject"),
                                                )
                                              ],
                                            )
                                          : order[index].status == "accepted"
                                              ? TextButton(
                                                  onPressed: () {
                                                    _changeOrderStatus(
                                                        "${order[index].id}");
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.white),
                                                  ),
                                                  child: const Text("Transit"),
                                                )
                                              : order[index].status ==
                                                      "in_transit"
                                                  ? TextButton(
                                                      onPressed: () {
                                                        _changeOrderStatus(
                                                            "${order[index].id}");
                                                      },
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                Colors.white),
                                                      ),
                                                      child:
                                                          const Text("Deliver"),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {
                                                        _changeOrderStatus(
                                                            "${order[index].id}");
                                                      },
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                Colors.white),
                                                      ),
                                                      child:
                                                          const Text("Delete"),
                                                    ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order[index].ppickupAddress,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        order[index].deliveryAddress,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order[index].receiverPhone,
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                          child: Text(
                                            order[index].status,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 51, 52, 51),
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                          "No orders available",
                          style: TextStyle(color: Colors.white30, fontSize: 30),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

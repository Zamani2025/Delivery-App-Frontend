import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/service/order_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = false;

  Future<void> _cancelOrders(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/cancel-orders/$id/"),
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

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 99, 2, 38),
          appBar: AppBar(
            title: const Text(
              "My Order",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 99, 2, 38),
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
          ),
          body: FutureBuilder(
            future: ordersProvider.fetchTrend(),
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
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    order[index].status == "delivered"
                                        ? TextButton(
                                            onPressed: () {
                                              _cancelOrders(
                                                  "${order[index].id}");
                                            },
                                            style: const ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.white),
                                            ),
                                            child: const Text("Delete"),
                                          )
                                        : order[index].status == "cancelled"
                                            ? TextButton(
                                                onPressed: () {
                                                  _cancelOrders(
                                                      "${order[index].id}");
                                                },
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                    Colors.white,
                                                  ),
                                                ),
                                                child: const Text("Delete"),
                                              )
                                            : order[index].status == "pending"
                                                ? TextButton(
                                                    onPressed: () {
                                                      _cancelOrders(
                                                          "${order[index].id}");
                                                    },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                        Colors.white,
                                                      ),
                                                    ),
                                                    child: const Text("Cancel"),
                                                  )
                                                : Center()
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
          )),
    );
  }
}

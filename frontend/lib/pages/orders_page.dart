import 'package:flutter/material.dart';
import 'package:frontend/service/order_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xFFF50057),
        appBar: AppBar(
          title: const Text(
            "My Order",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: const Color(0xFFF50057),
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
                      style:
                          const TextStyle(color: Colors.white30, fontSize: 30),
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
                    final dta = DateFormat("yyyy-MM-dd").parse(order[index].createdAt);
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
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
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Order Date ${dta}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete, color: Colors.red,))
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
        ));
  }
}

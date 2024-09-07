import 'package:flutter/material.dart';
import 'package:frontend/components/dashboard_item.dart';
import 'package:frontend/components/drawer_page.dart';
import 'package:frontend/pages/notification_page.dart';
import 'package:frontend/pages/orders_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                                              child: ListView(
                                            children: [
                                              TextFormField(
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
                                                              Radius.circular(
                                                                  15))),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
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
                                                              Radius.circular(
                                                                  15))),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
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
                                                              Radius.circular(
                                                                  15))),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
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
                                                              Radius.circular(
                                                                  15))),
                                                ),
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const DashboardItem(
                                iconData: Icons.shopping_bag,
                                text: "Send Order",
                              ),
                            ),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(),
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
                                iconData: Icons.money,
                                text: "Check Price",
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

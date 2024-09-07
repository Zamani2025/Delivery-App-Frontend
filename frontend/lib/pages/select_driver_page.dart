import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelectDriverPage extends StatefulWidget {
  final int deliverId;
  const SelectDriverPage({super.key, required this.deliverId});

  @override
  State<SelectDriverPage> createState() => _SelectDriverPageState();
}

class _SelectDriverPageState extends State<SelectDriverPage> {
  bool isSecure = true;
  bool isLoading = false;
  List driverss = [];

  Future<void> _fetchDrivers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/drivers/"),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      setState(() {
        driverss = jsonDecode(response.body);
      });
    }
  }

  Future<void> _assignDriver(int driverId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString("access_token");
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/driver/$driverId"), headers: {
      "Content-type": 'application/json',
      "Authorization": "Bearer $accessToken"
    }, body: {
      "driver_id": driverId
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Driver assigned successfully"),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fail to assign driver."),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchDrivers();
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        "Select Drvier",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      driverss.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 328,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: driverss.length,
                                itemBuilder: (context, index) {
                                  print(driverss[index]);
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                        driverss[index]['user']['first_name'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 80, 4),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        driverss[index]['phone_number']
                                            .toString(),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 233, 175, 2),
                                        ),
                                      ),
                                      trailing: ElevatedButton(
                                          onPressed: () => _assignDriver(driverss[index]['id']),
                                          child: const Text("Assign")),
                                      leading: const Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
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

import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/service/user_service.dart';

// ignore: must_be_immutable
class DrawerPage extends StatefulWidget {
  String? email;
  String? firstName;
  String? lastName;
  DrawerPage(
      {super.key,
      required this.email,
      required this.firstName,
      required this.lastName});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 99, 2, 38),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: 300,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 85,
              // color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 99, 2, 38),
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.firstName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "${widget.email}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                'My Orders',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.shopping_bag,
                color: Colors.white,
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                'Help',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.help_center_outlined,
                color: Colors.white,
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                'Invite a freind',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.people,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false)
                    });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("You have been logged out"),
                    backgroundColor: Colors.black,
                    elevation: 2.0,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                        label: "Dismiss",
                        textColor: const Color.fromARGB(255, 99, 2, 38),
                        disabledBackgroundColor: Colors.white,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        }),
                  ),
                );
              },
              child: const ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

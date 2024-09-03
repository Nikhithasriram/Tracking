import 'package:flutter/material.dart';
// import 'package:tracking_app/pages/info.dart';
import 'package:tracking_app/authentication.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/services/auth.dart';
import 'package:tracking_app/pages/pdf_pages/pdf_page_content.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Drawer(
            child: ListView(
              children: [
                // Container(
                //   height: 100,
                //   decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(20)),
                // ),
                const SizedBox(
                  height: 100,
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Authentication(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text("Export and Send"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PDFPage(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text("Sign Out"),
                  onTap: () async {
                    setState(() {
                      loading = false;
                    });
                    await AuthService().signOut(context);
                    setState(() {
                      loading = true;
                    });
                  },
                ),
              ],
            ),
          );
  }
}

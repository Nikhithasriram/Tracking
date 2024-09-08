import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tracking_app/pages/info.dart';
import 'package:tracking_app/authentication.dart';
import 'package:tracking_app/services/user.dart';
import 'package:tracking_app/utils/edit_profile_alert.dart';
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
  // late Future<AppUser> user;
  // late AppUser data;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: User().getuser,
        initialData: AppUser(),
        child: const DrawerContent());
  }
}

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppUser>(context);
    // print(data?.name ?? "Hello" );
    // return Container();
    return Drawer(
      child: loading
          ? const Center(
              child: Loading(),
            )
          : ListView(
              children: [
                // Container(
                //   height: 100,
                //   decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(20)),
                // ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 50,
                    child: Text(
                      data.name[0],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  onTap: () {
                    showUserDialog(context);
                  },
                ),
                const SizedBox(
                  height: 3,
                ),
                Center(child: Text('name:${data.name}')),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Edit Profile"),
                  onTap: () {
                    showUserDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(
                    "Home",
                  ),
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

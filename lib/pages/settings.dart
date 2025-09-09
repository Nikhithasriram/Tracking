import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/services/auth.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/utils/my_drawer.dart';
import 'package:firebase_functions/firebase_functions.dart';
// import 'package:fire';
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            backgroundColor: Colors.blueGrey.shade50,
            body: const Center(child: Loading()))
        : Scaffold(
            backgroundColor: Colors.blueGrey.shade50,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey.shade50,
              title: const Text("PD Tracker"),
              elevation: 0,
            ),
            drawer: const MyDrawer(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Card(
                      color: Colors.blueGrey.shade50,
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.shield_outlined),
                            title: const Text("Privacy Policy"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: const Icon(Icons.mail_outline),
                            title: const Text("Feedback and contact"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text("App version"),
                            trailing: const Text("v1.0.0"),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Account",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Card(
                      color: Colors.blueGrey.shade50,
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.login_rounded),
                            title: const Text("Sign Out"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Sign Out"),
                                      content: const Text(
                                          "Are you sure you want to sign out"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await AuthService()
                                                  .signOut(context);
                                              setState(() {
                                                loading = false;
                                              });
                                              if (!context.mounted) return;
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Sign out")),
                                        FilledButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"))
                                      ],
                                    );
                                  });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: const Text("Delete Account"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Account"),
                                      content: const Text(
                                          "Are you sure you want to delete your account? This action is permanent and all your data will be deleted.\nThis action cannot be undone"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              final reAuthRequired =
                                                  AuthService()
                                                      .needesReauthentication();
                                              if (reAuthRequired) {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Delete Account"),
                                                        content: const Text(
                                                            "For security reasons please login again to delete Your account"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  loading =
                                                                      true;
                                                                });
                                                                await AuthService()
                                                                    .signOut(
                                                                        context);
                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });
                                                                if (!context
                                                                    .mounted) {
                                                                  return;
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "Cancel")),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await AuthService()
                                                                    .signOut(
                                                                        context);
                                                              },
                                                              child: const Text(
                                                                  "Login Again")),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                // FirebaseF
                                                // firebaseF
                                                FirebaseFunctions.instance.httpsCallable
                                              }
                                            },
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        FilledButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"))
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

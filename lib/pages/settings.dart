// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/authentication.dart';
import 'package:tracking_app/models/authclass.dart';
import 'package:tracking_app/services/auth.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/utils/my_drawer.dart';
import 'package:tracking_app/utils/my_snackbar.dart';
// import 'package:firebase_functions/firebase_functions.dart';
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
                              signout(context);
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
                              deleteAccount(context);
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

  Future<dynamic> deleteAccount(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext outercontext) {
          return AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
                "Are you sure you want to delete your account? This action is permanent and all your data will be deleted.\nThis action cannot be undone"),
            actions: [
              TextButton(
                  onPressed: () async {
                    final reAuthRequired =
                        AuthService().needesReauthentication();
                    if (reAuthRequired) {
                      Navigator.of(outercontext).pop();
                      showDialog(
                          context: context,
                          builder: (dialogcontext) {
                            return AlertDialog(
                              title: const Text("Delete Account"),
                              content: const Text(
                                  "For security reasons please login again to delete Your account"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(dialogcontext).pop();
                                      setState(() {
                                        loading = true;
                                      });
                                      final result =
                                          await AuthService().signOut();
                                      setState(() {
                                        loading = false;
                                      });
                                      if (result is Failure) {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        showsnackbar(context , result.errorMessage);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(
                                        //         content:
                                        //             Text(result.errorMessage)));
                                      } else {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                          return const Authentication();
                                        }), (route) => false);
                                        // print("remove this layer");
                                        // Navigator.of(context).pop();
                                      }
                                      // if (!context
                                      //     .mounted) {
                                      //   return;
                                      // }
                                      // Navigator.of(
                                      //         context)
                                      //     .pop();
                                    },
                                    child: const Text("Login Again")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogcontext).pop();
                                    },
                                    child: const Text("Cancel")),
                              ],
                            );
                          });
                    } else {
                      // relogin not required
                      // FirebaseF
                      // firebaseF
                      // FirebaseFunctions.instance.httpsCallable
                      Navigator.of(outercontext).pop();
                      setState(() {
                        loading = true;
                      });
                      final result = await AuthService().deleteUserData();
                      if (result is Success) {
                        final signoutresult = await AuthService().signOut();
                        setState(() {
                          loading = false;
                        });
                        if (!context.mounted) {
                          return;
                        }
                        // Navigator.of(context).pop();
                        if (signoutresult is Failure) {
                          showsnackbar(context, "User data deleted Successfully , Please logout ");
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text(
                          //         "User data deleted Successfully , Please logout ")));
                        }
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const Authentication();
                        }), (route) => false);
                        showsnackbar(context, "User and User data deleted Successfully");
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         "User and User data deleted Successfully")));
                      } else if (result is Failure) {
                        if (!context.mounted) {
                          return;
                        }
                        showsnackbar(context,  "error deleting data ${result.errorMessage}");
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         "error deleting data ${result.errorMessage}")));
                      }
                    }
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  )),
              FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  Future<dynamic> signout(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            title: const Text("Sign Out"),
            content: const Text("Are you sure you want to sign out"),
            actions: [
              TextButton(
                  onPressed: () async {
                    //removes the popup
                    Navigator.of(dialogcontext).pop();
                    setState(() {
                      loading = true;
                    });
                    final result = await AuthService().signOut();
                    setState(() {
                      loading = false;
                    });
                    if (!context.mounted) return;
                    if (result is Failure) {
                      showsnackbar(context, "Unable to signout ${result.errorMessage}");
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //         "Unable to signout ${result.errorMessage}")));
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                        return const Authentication();
                      }), (route) => false);
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      // Navigator.of(context)
                      //     .pushAndRemoveUntil(MaterialPageRoute(
                      //   builder: (context) {
                      //     // print("this is hapening");
                      //     return const Authentication();
                      //   },
                      // ),
                      //         (Route<dynamic>
                      //                 route) =>
                      //             false);
                      // Navigator.of(context).pop();
                    }
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
  }
}

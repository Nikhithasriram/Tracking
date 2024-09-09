import 'package:flutter/material.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/services/auth.dart';

class SignOut extends StatefulWidget {
  const SignOut({super.key});

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            backgroundColor: Colors.blueGrey.shade50,
            body: const Center(child: Loading()))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey.shade50,
              title: const Text("PD Tracker"),
            ),
            backgroundColor: Colors.blueGrey.shade50,
            body: Center(
              child: FilledButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await AuthService().signOut(context);
                    setState(() {
                      loading = false;
                    });
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Sign Out")),
            ),
          );
  }
}

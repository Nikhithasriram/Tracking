import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/pages/sign_in.dart';
import 'package:tracking_app/pages/bottom_navigation.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    User? myuser = Provider.of<User?>(context);
    if (myuser == null) {
      return const SignIn();
    } else {
      return const MyBottomNavigation();
    }
  }
}

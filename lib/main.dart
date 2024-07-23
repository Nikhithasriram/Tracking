import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/bottom_navigation.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
// import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_) => WeightProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyBottomNavigation()
      ),
    );
  }
}


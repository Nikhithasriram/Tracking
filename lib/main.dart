import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:tracking_app/Provider/waterprovider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeightProvider>(create: (_) => WeightProvider()),
        ChangeNotifierProvider<WaterProvider>(create: (_) => WaterProvider()),
        ChangeNotifierProvider<DialysisProvier>(create: (_) => DialysisProvier()),

      ],
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


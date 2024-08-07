import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:tracking_app/Provider/waterprovider.dart';
import 'package:tracking_app/authentication.dart';
import 'package:tracking_app/services/auth.dart';
// import 'pages/bottom_navigation.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(value: AuthService().user, initialData: null),
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
        home: const Authentication(),
      ),
    );
  }
}


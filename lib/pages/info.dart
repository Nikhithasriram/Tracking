import 'package:flutter/material.dart';
import 'info/weight.dart';
import 'info/water.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  List<Widget> tabs = const [
    WeightPage(),
    Water(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade50,
          title: const Text("Tracking"),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Weight",
              ),
              Tab(
                text: "Water",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: tabs,
        ),
      ),
    );
  }
}


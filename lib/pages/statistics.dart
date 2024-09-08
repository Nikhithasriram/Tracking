import 'package:flutter/material.dart';
import 'package:tracking_app/pages/graphs/graph_page.dart';
import 'package:tracking_app/utils/my_drawer.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade50,
          title: const Text("PD Tracker"),
          elevation: 0,
        ),
        backgroundColor: Colors.blueGrey.shade50,
        drawer:const MyDrawer(),
        body: const GraphPage());
  }
}

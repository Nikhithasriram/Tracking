import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tracking_app/pages/info/dialysis.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/utils/my_drawer.dart';
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
    DialysisPage(),
  ];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey.shade50,
                title: const Text("PD Tracker"),
                elevation: 0,
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "Weight",
                    ),
                    Tab(
                      text: "Water",
                    ),
                    Tab(
                      text: "Dialysis",
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: tabs,
              ),
              drawer: const MyDrawer(),
            ),
          );
  }
}

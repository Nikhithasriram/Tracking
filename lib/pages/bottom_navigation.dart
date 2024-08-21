import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/models/dialysis.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/services/database_dialysis.dart';
import 'package:tracking_app/services/database_water.dart';
import 'package:tracking_app/services/database_weight.dart';


import 'statistics.dart';
import 'info.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({super.key});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int currenindex = 0;
  List<Widget> screens = const [Info(), StatisticsPage()];
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          StreamProvider<List<NewWeight>>.value(value: DatabaseWeights().weights, initialData:const []),
        StreamProvider<List<DayWater>>.value(value: DatabaseWater().waters, initialData:const []),
        StreamProvider<List<DialysisReading>>.value(value: DatabaseDialysis().dialysis, initialData: []),

      ],
      child: Scaffold(
          
          body: screens[currenindex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currenindex,
            onTap: (index) {
              setState(() {
                currenindex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.auto_graph_rounded), label: "Statistics")
            ],
          )),
    );
  }
}

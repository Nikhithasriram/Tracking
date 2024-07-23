import 'package:flutter/material.dart';
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
    return Scaffold(
        
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
        ));
  }
}

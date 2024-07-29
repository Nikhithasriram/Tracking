import 'package:flutter/material.dart';
// import 'package:expansion_tile_group/expansion_tile_group.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.blueGrey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ExpansionPanelList.radio(
              materialGapSize: 10,
              elevation: 0,
              dividerColor: Colors.transparent,
              children: [
                ExpansionPanelRadio(
                    value: "hello",
                    headerBuilder: (context, isExpanded) => const Padding(
                      padding:  EdgeInsets.all(16.0),
                      child:  Text("Hello"),
                    ),
                    body: const Text("Is expanded good tkbjverkjbkjbkjbkjb")),
                  
                ExpansionPanelRadio(
                    value: "bye",
                    headerBuilder: (context, isExpanded) => const Text("Hello"),
                    body: const Text("Is expanded good tkbjverkjbkjbkjbkjb")),
                ExpansionPanelRadio(
                    value: "good",
                    headerBuilder: (context, isExpanded) => const Text("Hello"),
                    body: const Text("Is expanded good tkbjverkjbkjbkjbkjb")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

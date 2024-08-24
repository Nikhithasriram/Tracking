import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/utils/weight_utils/listtile.dart';
import 'package:tracking_app/utils/weight_utils/showdialog.dart';

import '../no_data_yet.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightState();
}

class _WeightState extends State<WeightPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<NewWeight> content = Provider.of<List<NewWeight>>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: content.isEmpty
          ? const NoDataYet()
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: content.length,
                itemBuilder: (context, index) {
                  return MylistTile(
                      weight: content[index].weight,
                      date: content[index].date,
                      time: content[index].time,
                      notes: content[index].notes,
                      uuid: content[index].uuid);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createnewElement(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

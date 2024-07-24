import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:tracking_app/utils/listtile.dart';
import 'package:tracking_app/utils/alert_dialog.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightState();
}

class _WeightState extends State<WeightPage> {
  void createnewElement({int index = -1}) {
    // print(context);
    showDialog(
        context: context,
        builder: (context) {
          return ScaffoldMessenger(
            child: MyAlertDialog(
              index: index,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Consumer<WeightProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    createnewElement(
                      index: index,
                    );
                  },
                  child: MylistTile(
                      weight: value.items[index].weight,
                      date: value.items[index].date,
                      time: value.items[index].time,
                      notes: value.items[index].notes),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createnewElement();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

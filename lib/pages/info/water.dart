import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/waterprovider.dart';
import 'package:tracking_app/functions/global_var.dart';
import 'package:tracking_app/utils/water_utils/waterdialog.dart';
import 'package:tracking_app/utils/water_utils/waterlistTile.dart';

class Water extends StatelessWidget {
  const Water({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Consumer<WaterProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              // physics:  const NeverScrollableScrollPhysics(),
              key: Key(waterselected.toString()),
              // key: UniqueKey(),
              itemCount: value.items.length,
              itemBuilder: (context, index) {
                return WaterListTile(
                  daily: value.items[index],
                  index: index,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          waterdialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

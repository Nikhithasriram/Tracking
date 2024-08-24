import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/waterprovider.dart';
// import 'package:tracking_app/functions/global_var.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/pages/no_data_yet.dart';
import 'package:tracking_app/utils/water_utils/waterdialog.dart';
import 'package:tracking_app/utils/water_utils/waterlistTile.dart';

class Water extends StatelessWidget {
  const Water({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<List<DayWater>>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: value.isEmpty
          ? const NoDataYet()
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return WaterListTile(
                    daily: value[index],
                    uuid: value[index].uuid,
                  );
                },
              ),
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

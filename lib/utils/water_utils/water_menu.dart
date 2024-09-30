import 'package:flutter/material.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/services/database_water.dart';
import 'package:tracking_app/utils/water_utils/waterdialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tracking_app/utils/water_utils/water_confirm_delete.dart';

class WaterMenu extends StatelessWidget {
  final String uuid;
  final String subuuid;
  const WaterMenu({super.key, required this.uuid, required this.subuuid});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
        builder: (context, controller, child) {
          return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.more_vert_rounded));
        },
        menuChildren: [
          IconButton(
              onPressed: () {
                waterdialog(context: context, uuid: uuid, subuuid: subuuid);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                // final value = context
                //     .read<WaterProvider>()
                //     .items[index]
                //     .dayContents[dailyconentsindex];
                final value = await DatabaseWater()
                    .getwaterwithsubuuid(uuid: uuid, subuuid: subuuid);
                String text = value.type == Watertype.intake
                    ? "Intake"
                    : value.type == Watertype.output
                        ? "output"
                        : "misc";
                // print("valueeeee is $value");
                await Share.share(
                    '$text: ${value.value}ml \ndate: ${value.date} \ntime: ${value.time}');
                //todo implement share
              },
              icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return WaterConfirmDelete(uuid: uuid, subuuid: subuuid , dialogcontext: dialogContext,);
                    });
              },
              icon: const Icon(Icons.delete)),
        ]);
  }
}

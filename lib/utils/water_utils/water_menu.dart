import 'package:flutter/material.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/utils/water_utils/waterdialog.dart';
import 'package:tracking_app/Provider/waterprovider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tracking_app/utils/water_utils/water_confirm_delete.dart';

class WaterMenu extends StatelessWidget {
  final int index;
  final int dailyconentsindex;
  const WaterMenu(
      {super.key, required this.index, required this.dailyconentsindex});

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
                waterdialog(
                    context: context,
                    index: index,
                    daycontents: dailyconentsindex);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                final value = context
                    .read<WaterProvider>()
                    .items[index]
                    .dayContents[dailyconentsindex];
                String text = value.type == Watertype.intake
                    ? "Intake"
                    : value.type == Watertype.output
                        ? "output"
                        : "misc";
                await Share.share(
                    '$text: ${value.value}ml \ndate: ${value.date} \ntime: ${value.time}');
              },
              icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return WaterConfirmDelete(
                          index: index, dailycontentsindex: dailyconentsindex);
                    });
              },
              icon: const Icon(Icons.delete)),
        ]);
  }
}
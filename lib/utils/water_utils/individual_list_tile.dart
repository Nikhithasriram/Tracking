import 'package:flutter/material.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/utils/water_utils/water_menu.dart';

class IndividualListtile extends StatelessWidget {
  final NewWater water;
  final int daycontentsindex;
  final int index;
  const IndividualListtile(
      {super.key,
      required this.water,
      required this.index,
      required this.daycontentsindex});

  @override
  Widget build(BuildContext context) {
    final String type = water.type == Watertype.intake
        ? "Intake"
        : water.type == Watertype.output
            ? "Output"
            : "Misc";
    return ListTile(
      dense: true,
      leading: Container(
        width: 3,
        color: water.type == Watertype.intake
            ? Colors.blue
            : water.type == Watertype.output
                ? Colors.amber
                : Colors.grey,
      ),
      title: Text(
        "$type: ${water.value}ml",
        style: const TextStyle(fontSize: 15),
      ),
      contentPadding:
          const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
      subtitle: Text(water.notes),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            water.time,
            style: const TextStyle(fontSize: 13),
          ),
          WaterMenu(
            index: index,
            dailyconentsindex: daycontentsindex,
          )
        ],
      ),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
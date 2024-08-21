import 'package:flutter/material.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/utils/water_utils/waterdialog.dart';
import 'package:tracking_app/utils/water_utils/individual_list_tile.dart';

class WaterListTile extends StatefulWidget {
  final DayWater daily;
  final String uuid;
  const WaterListTile({super.key, required this.daily, required this.uuid});

  @override
  State<WaterListTile> createState() => _WaterListTileState();
}

class _WaterListTileState extends State<WaterListTile> {
  @override
  Widget build(BuildContext context) {
    // print(waterselected);
    // print(widget.uuid);
    // print(widget.daily.dayContents[0].uuid);
    // widget.daily.dayContents.forEach((e) {
    //   print(e.uuid);
    // });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 3),
          controlAffinity: ListTileControlAffinity.leading,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Input: ${widget.daily.intakeml} ml"),
              Text("Output: ${widget.daily.outputml} ml"),
            ],
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.daily.date,
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                  onPressed: () {
                    waterdialog(context: context, uuid: widget.uuid);
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          childrenPadding: const EdgeInsets.all(10),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.daily.dayContents
                        .map((water) => IndividualListtile(
                            water: water,
                            uuid: widget.uuid,
                            subuuid: water.uuid))
                        .toList(),
                  ),
                )),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysisdialog.dart';

import 'dialysis_individual_tile.dart';

class DialysisTile extends StatelessWidget {
  final String uuid;
  final DialysisReading reading;
  const DialysisTile({super.key, required this.uuid, required this.reading});

  @override
  Widget build(BuildContext context) {
    int i = 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Net out: ${reading.netml} ml"),
        controlAffinity: ListTileControlAffinity.leading,
        tilePadding: const EdgeInsets.only(left: 8, right: 4),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reading.date,
              style: const TextStyle(fontSize: 14),
            ),
            IconButton(
                onPressed: () {
                  dialysisdialog(context: context, uuid: uuid);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: reading.session
                      .map((r) => DialysisIndividualTile(
                            onesessionreadings: r,
                            subuuid: r.uuid,
                            uuid: uuid,
                            index: i++,
                          ))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}

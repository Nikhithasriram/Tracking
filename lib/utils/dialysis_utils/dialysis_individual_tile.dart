import 'package:flutter/material.dart';
import 'package:tracking_app/models/dialysisclass.dart';
// import 'package:tracking_app/utils/dialysis_utils/dialysis_tile.dart';

import 'dialysis_menu.dart';


class DialysisIndividualTile extends StatelessWidget {
  final Onesession onesessionreadings;
  final String uuid;
  final String subuuid;
  final int index;

  const DialysisIndividualTile(
      {super.key,
      required this.onesessionreadings,
      required this.uuid,
      required this.subuuid,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 3,
                color: Colors.purple.shade300,
              ),
            ),
            // const SizedBox(
            //   width: 4,
            // ),
            Text(
              index.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      dense: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          onesessionreadings.inml != 0
              ? Text(
                  "In :${onesessionreadings.inml.toString()}ml",
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 8,
          ),
          onesessionreadings.outml != 0
              ? Text(
                  "Out :${onesessionreadings.outml.toString()}ml",
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
        ],
      ),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.only(left: 2, right: 2),
      subtitle: Text(onesessionreadings.notes),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                " net :${onesessionreadings.sessionnet.toString()} ml",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                onesessionreadings.time,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          DialysisMenu(
            uuid: uuid,
            subuuid: subuuid,
          )
        ],
      ),
    );
  }
}

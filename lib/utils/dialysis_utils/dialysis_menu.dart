import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tracking_app/services/database_dialysis.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_confirm_delete.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysisdialog.dart';


class DialysisMenu extends StatelessWidget {
  final String uuid;
  final String subuuid;
  const DialysisMenu({super.key, required this.uuid, required this.subuuid});

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
            icon: const Icon(Icons.more_vert));
      },
      menuChildren: [
        IconButton(
            onPressed: () {
              dialysisdialog(context: context, uuid: uuid, subuuid: subuuid);
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              final value = await DatabaseDialysis()
                  .onesessionreading(uuid: uuid, subuuid: subuuid);
              // final value = context
              //     .read<DialysisProvier>()
              //     .items[index]
              //     .session[subindex];
              if (value != null) {
                await Share.share(
                    "In: ${value.inml} \nOut: ${value.outml} \nNetout :${value.sessionnet} \nDate: ${value.date} \nTime: ${value.time}");
              }
            },
            icon: const Icon(Icons.share)),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialysisConfirmDelete(uuid: uuid, subuuid: subuuid);
                },
              );
            },
            icon: const Icon(Icons.delete))
      ],
    );
  }
}

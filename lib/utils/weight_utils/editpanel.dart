import 'package:flutter/material.dart';
import 'package:tracking_app/services/database.dart';
import 'package:tracking_app/utils/weight_utils/showdialog.dart';
import 'package:tracking_app/utils/weight_utils/confirmdelete.dart';
import 'package:share_plus/share_plus.dart';

class EditPanel extends StatelessWidget {
  final String uuid;
  const EditPanel({super.key, required this.uuid});

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
                createnewElement(context: context, uuid: uuid);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                final value = await Database().docValues(uuid: uuid);
                await Share.share(
                'weight: ${value.weight} \ndate: ${value.date}\n time: ${value.time}');
                
              },
              icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDelete(uuid: uuid);
                    });
              },
              icon: const Icon(Icons.delete)),
        ]);
  }
}

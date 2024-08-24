import 'package:flutter/material.dart';
import 'package:tracking_app/services/database_dialysis.dart';
// import 'package:tracking_app/Provider/dialysisprovider.dart';
// import 'package:provider/provider.dart';

class DialysisConfirmDelete extends StatelessWidget {
  final String subuuid;
  final String uuid;
  const DialysisConfirmDelete(
      {super.key, required this.uuid, required this.subuuid});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () {
              // TODO : delete
              // final value = context.read<DialysisProvier>();
              // value.delete(index: index, subindex: subindex);
              DatabaseDialysis().delete(uuid: uuid, subuuid: subuuid);
              Navigator.of(context).pop();
            },
            child: const Text("delete")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("cancel")),
      ],
    );
  }
}

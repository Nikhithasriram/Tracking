import 'package:flutter/material.dart';
import 'package:tracking_app/services/database_dialysis.dart';
// import 'package:tracking_app/Provider/dialysisprovider.dart';
// import 'package:provider/provider.dart';

class DialysisConfirmDelete extends StatelessWidget {
  final String subuuid;
  final String uuid;
  final BuildContext dialogcontext;
  const DialysisConfirmDelete(
      {super.key,
      required this.uuid,
      required this.subuuid,
      required this.dialogcontext});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Reading will be Permanently deleted \nAre you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () async {
              // final value = context.read<DialysisProvier>();
              // value.delete(index: index, subindex: subindex);
              await DatabaseDialysis().delete(uuid: uuid, subuuid: subuuid);
              if (!context.mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(dialogcontext).showSnackBar(
                  const SnackBar(content: Text("Reading Deleted") , behavior: SnackBarBehavior.floating,));
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

import 'package:flutter/material.dart';
import 'package:tracking_app/services/database_weight.dart';

class ConfirmDelete extends StatelessWidget {
  final String uuid;
  final BuildContext dialogcontext;
  const ConfirmDelete(
      {super.key, required this.uuid, required this.dialogcontext});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text(
          "Reading will be Permanently deleted \nAre you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () async {
              await DatabaseWeights().delete(uuid: uuid);
              if (!context.mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(dialogcontext).showSnackBar(const SnackBar(
                  content: Text("Reading Deleted"),
                  behavior: SnackBarBehavior.floating));
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

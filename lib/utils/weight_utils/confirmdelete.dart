import 'package:flutter/material.dart';
import 'package:tracking_app/services/database_weight.dart';

class ConfirmDelete extends StatelessWidget {
  final String uuid;
  const ConfirmDelete({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () {
              DatabaseWeights().delete(uuid: uuid);
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

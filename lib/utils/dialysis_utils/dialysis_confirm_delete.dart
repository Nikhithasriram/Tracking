import 'package:flutter/material.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:provider/provider.dart';

class DialysisConfirmDelete extends StatelessWidget {
  final int subindex;
  final int index;
  const DialysisConfirmDelete({super.key, required this.index , required this.subindex});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () {
              final value = context.read<DialysisProvier>();
              value.delete(index: index, subindex: subindex);
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

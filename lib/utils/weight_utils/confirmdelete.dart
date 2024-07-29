import 'package:flutter/material.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:provider/provider.dart';

class ConfirmDelete extends StatelessWidget {
  final int index;
  const ConfirmDelete({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () {
              final value = context.read<WeightProvider>();
              value.delete(value.items[index]);
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

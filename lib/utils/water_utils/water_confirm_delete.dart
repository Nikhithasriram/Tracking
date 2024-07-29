import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/waterprovider.dart';

class WaterConfirmDelete extends StatelessWidget {
  final int index;
  final int dailycontentsindex;

  const WaterConfirmDelete(
      {super.key, required this.index, required this.dailycontentsindex});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () {
              context.read<WaterProvider>().delete(index, dailycontentsindex);
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

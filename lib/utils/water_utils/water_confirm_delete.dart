import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/waterprovider.dart';
import 'package:tracking_app/services/database_water.dart';

class WaterConfirmDelete extends StatelessWidget {
  final String uuid;
  final String subuuid;
  final BuildContext dialogcontext;

  const WaterConfirmDelete(
      {super.key, required this.uuid, required this.subuuid , required this.dialogcontext});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete"),
      content: const Text("Reading will be Permanently deleted \nAre you sure you want to delete the reading ? "),
      actions: [
        TextButton(
            onPressed: () async {
              // context.read<WaterProvider>().delete(index, dailycontentsindex);
              //todo delete

              await DatabaseWater().delete(uuid: uuid, subuuid: subuuid);
              if (!context.mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(dialogcontext).showSnackBar(
                  const SnackBar(content: Text("Reading Deleted") , behavior: SnackBarBehavior.floating));
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

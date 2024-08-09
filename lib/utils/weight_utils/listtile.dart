import 'package:flutter/material.dart';
import 'package:tracking_app/utils/weight_utils/editpanel.dart';

class MylistTile extends StatelessWidget {
  const MylistTile(
      {super.key,
      required this.weight,
      required this.date,
      required this.time,
      required this.notes,
      required this.uuid});
  final double weight;
  final String date;
  final String time;
  final String notes;
  final String uuid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: ListTile(
        title: Text(
          "Weight: $weight kg",
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(notes),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            EditPanel(uuid: uuid)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
      ),
    );
  }
}




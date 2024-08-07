import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:tracking_app/utils/weight_utils/editpanel.dart';

class MylistTile extends StatelessWidget {
  const MylistTile(
      {super.key,
      required this.weight,
      required this.date,
      required this.time,
      required this.notes,
      required this.index});
  final double weight;
  final String date;
  final String time;
  final String notes;
  final int index;

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
            EditPanel(index: index)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
      ),
    );
  }
}



// class ConfirmDelete extends StatelessWidget {
//   final int index;
//   const ConfirmDelete({super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Delete"),
//       content: const Text("Are you sure you want to delete the reading ? "),
//       actions: [
//         TextButton(
//             onPressed: () {
//               final value = context.read<WeightProvider>();
//               value.delete(value.items[index]);
//               Navigator.of(context).pop();
//             },
//             child: const Text("delete")),
//         TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text("cancel")),
//       ],
//     );
//   }
// }

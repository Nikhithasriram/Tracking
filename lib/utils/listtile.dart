import 'package:flutter/material.dart';
// import 'package:tracking_app/pages/info/weight.dart';
// import 'package:tracking_app/utils/alert_dialog.dart';

class MylistTile extends StatelessWidget {
 const MylistTile(
      {super.key,
      required this.weight,
      required this.date,
      required this.time,
      required this.notes});
  final double weight;
  final String date;
  final String time;
  final String notes;

  // final TextEditingController weightcontroller = TextEditingController();
  // final TextEditingController datecontroller = TextEditingController();
  // final TextEditingController timecontroller = TextEditingController();
  // final TextEditingController notescontroller = TextEditingController();

  // void initializecontroller() {
  //   weightcontroller.text = weight.toString();
  //   datecontroller.text = date;
  //   timecontroller.text = time;
  //   notescontroller.text = notes;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: ListTile(
        onTap: () {
          // editinfo();
        },
        title: Text(
          "Weight: $weight kg",
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(notes),
        trailing: Column(
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
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

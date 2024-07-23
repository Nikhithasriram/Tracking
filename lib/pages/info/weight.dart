import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
// import 'package:flutter/widgets.dart';
import 'package:tracking_app/utils/listtile.dart';
// import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/utils/alert_dialog.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightState();
}

class _WeightState extends State<WeightPage> {
  // TextEditingController datecontroller = TextEditingController();
  // TextEditingController timecontroller = TextEditingController();
  // TextEditingController weightcontroller = TextEditingController();
  // TextEditingController notescontroller = TextEditingController();

  // List<NewWeight> dataOfWeights = [
  //   NewWeight(weight: 80.0, date: "8th July", time: "7:00 AM", notes: "Heloo"),
  //   NewWeight(weight: 81, date: "9th July", time: "7:00 AM"),
  //   NewWeight(weight: 79, date: "10th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  //   NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  // ];

  // void addNewReading(context) {
  //   setState(() {
  //     if (weightcontroller.text != "") {
  //       dataOfWeights.insert(
  //           0,
  //           NewWeight(
  //               weight: double.parse(weightcontroller.text),
  //               date: datecontroller.text,
  //               time: timecontroller.text,
  //               notes: notescontroller.text));
  //       Navigator.pop(context);
  //     } else {
  //       const snackBar = SnackBar(
  //         content: Text("Please enter the weight"),
  //         behavior: SnackBarBehavior.floating,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   });
  // }

  // void initializeController() {
  //   DateTime now = DateTime.now();
  //   TimeOfDay time = TimeOfDay.now();
  //   String nowdate =
  //       "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
  //   datecontroller.text = nowdate;
  //   String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

  //   String nowTime =
  //       "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
  //   timecontroller.text = nowTime;

  //   weightcontroller.clear();
  //   notescontroller.clear();
  // }

  void createnewElement(context) {
    // initializeController();
    showDialog(
        context: context,
        builder: (context) {
          return const MyAlertDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Consumer<WeightProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.items.length,
              itemBuilder: (context, index) {
                return MylistTile(
                    weight: value.items[index].weight,
                    date: value.items[index].date,
                    time: value.items[index].time,
                    notes: value.items[index].notes);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createnewElement(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

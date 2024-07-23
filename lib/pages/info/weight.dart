import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:tracking_app/utils/listtile.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/utils/alert_dialog.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightState();
}

class _WeightState extends State<WeightPage> {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController weightcontroller = TextEditingController();
  TextEditingController notescontroller = TextEditingController();

  List<NewWeight> dataOfWeights = [
    NewWeight(weight: 80, date: "8th July", time: "7:00 AM", notes: "Heloo"),
    NewWeight(weight: 81, date: "9th July", time: "7:00 AM"),
    NewWeight(weight: 79, date: "10th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
    NewWeight(weight: 80, date: "11th July", time: "7:00 AM"),
  ];

  void addNewReading(context) {
    setState(() {
      if (weightcontroller.text != "") {
        dataOfWeights.insert(
            0,
            NewWeight(
                weight: int.parse(weightcontroller.text),
                date: datecontroller.text,
                time: timecontroller.text,
                notes: notescontroller.text));
        Navigator.pop(context);
      } else {
        const snackBar = SnackBar(
          content: Text("Please enter the weight"),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void initializeController() {
    DateTime now = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    String nowdate =
        "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    datecontroller.text = nowdate;
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timecontroller.text = nowTime;

    weightcontroller.clear();
    notescontroller.clear();
  }

  void createnewElement(context) {
    initializeController();
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog(
            datecontroller: datecontroller,
            timecontroller: timecontroller,
            weightcontroller: weightcontroller,
            notescontroller: notescontroller,
            addnewReading: () {
              addNewReading(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: dataOfWeights.length,
          itemBuilder: (context, index) {
            return MylistTile(
                weight: dataOfWeights[index].weight,
                date: dataOfWeights[index].date,
                time: dataOfWeights[index].time,
                notes: dataOfWeights[index].notes);
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

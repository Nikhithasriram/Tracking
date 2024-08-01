import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/waterprovider.dart';
import 'package:tracking_app/models/waterclass.dart';
// import 'package:tracking_app/models/waterclass.dart';

class WaterAlertDialog extends StatefulWidget {
  final int index;
  final int daycontentsindex;
  const WaterAlertDialog(
      {super.key, this.index = -1, this.daycontentsindex = -1});

  @override
  State<WaterAlertDialog> createState() => _WaterAlertDialogState();
}

class _WaterAlertDialogState extends State<WaterAlertDialog> {
  TextEditingController intakemlController = TextEditingController();
  TextEditingController outputmlController = TextEditingController();
  TextEditingController miscmlController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  void defaultInitializer() {
    DateTime now = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    String nowdate =
        "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    dateController.text = nowdate;
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timeController.text = nowTime;

    intakemlController.clear();
    outputmlController.clear();
    miscmlController.clear();
    notesController.clear();
  }

  void dateInitializer() {
    final value = Provider.of<WaterProvider>(context, listen: false);
    dateController.text = value.items[widget.index].date;
    TimeOfDay time = TimeOfDay.now();
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();
    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timeController.text = nowTime;
    intakemlController.clear();
    outputmlController.clear();
    miscmlController.clear();
    notesController.clear();
  }

  void updateInitializer() {
    final value = Provider.of<WaterProvider>(context, listen: false);
    final content =
        value.items[widget.index].dayContents[widget.daycontentsindex];
    if (content.type == Watertype.intake) {
      intakemlController.text = content.value.toString();
      outputmlController.clear();
      miscmlController.clear();
      // print("hi");
    } else if (content.type == Watertype.output) {
      outputmlController.text = content.value.toString();
      intakemlController.clear();
      miscmlController.clear();
    } else {
      miscmlController.text = content.value.toString();
      outputmlController.clear();
      intakemlController.clear();
    }

    dateController.text = value.items[widget.index].date;
    timeController.text = content.time;
    notesController.text = content.notes;
  }

  @override
  void initState() {
    // print(widget.daycontentsindex);
    if (widget.index == -1 && widget.daycontentsindex == -1) {
      // print("default");
      defaultInitializer();
    } else if (widget.index != -1 && widget.daycontentsindex == -1) {
      // print("date");
      dateInitializer();
    } else if (widget.daycontentsindex != -1 && widget.index != -1) {
      // print("eddit");
      updateInitializer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectDate() async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100));

      // picked ??= DateTime.now();

      setState(() {
        if (picked != null) {
          String pickedDate =
              "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
          dateController.text = pickedDate;
        }
      });
    }

    Future<void> selectTime() async {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
      );

      setState(() {
        if (time != null) {
          String min =
              time.minute < 10 ? "0${time.minute}" : time.minute.toString();
          timeController.text =
              "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        scrollable: true,
        title: Text(
            widget.daycontentsindex == -1 ? "New Reading" : "Update Reading"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: intakemlController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("ml"),
                  ),
                  hintText: "Water Intake",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: outputmlController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("ml"),
                  ),
                  hintText: "Urine Output",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: miscmlController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("ml"),
                  ),
                  hintText: "Miscellaneous",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              onTap: () {
                selectDate();
              },
              controller: dateController,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: "Date",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onTap: () {
                selectTime();
              },
              controller: timeController,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.access_time),
                  hintText: "Time",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.notes),
                  hintText: "Notes",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        actions: [
          FilledButton(
            // style: ButtonStyle(
            //     backgroundColor:
            //         WidgetStatePropertyAll(Colors.purple.shade200)),
            onPressed: () {
              final value = context.read<WaterProvider>();
              final double intakeml =
                  double.tryParse(intakemlController.text) ?? 0.0;
              final double outputml =
                  double.tryParse(outputmlController.text) ?? 0.0;
              final double miscml =
                  double.tryParse(miscmlController.text) ?? 0.0;
              final String date = dateController.text;
              final String time = timeController.text;
              final String notes = notesController.text;
              if (intakeml == 0.0 && miscml == 0.0 && outputml == 0.0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Enter atleast one valid value"),
                  behavior: SnackBarBehavior.floating,
                ));
              } else {
                if (widget.daycontentsindex == -1) {
                  value.add(intakeml, outputml, miscml, date, time, notes);
                } else {
                  value.delete(widget.index, widget.daycontentsindex);
                  value.add(intakeml, outputml, miscml, date, time, notes);
                }

                Navigator.of(context).pop();
              }

              // print(value.items);
            },
            child: Text(
              widget.daycontentsindex == -1 ? "Save" : "Update",
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("cancel"))
        ],
      ),
    );
  }
}

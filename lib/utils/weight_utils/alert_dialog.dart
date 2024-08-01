import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/weightprovider.dart';
import 'package:tracking_app/models/weightclass.dart';
// import 'package:expansion_tile_group/expansion_tile_group.dart';

class MyAlertDialog extends StatefulWidget {
  final int index;
  const MyAlertDialog({super.key, this.index = -1});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController weightcontroller = TextEditingController();
  final TextEditingController notescontroller = TextEditingController();

  void defaultinitializer() {
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

  @override
  void initState() {
    if (widget.index == -1) {
      defaultinitializer();
    } else {
      final value = Provider.of<WeightProvider>(context, listen: false);
      weightcontroller.text = value.items[widget.index].weight.toString();
      datecontroller.text = value.items[widget.index].date;
      timecontroller.text = value.items[widget.index].time;
      notescontroller.text = value.items[widget.index].notes;
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
          datecontroller.text = pickedDate;
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
          timecontroller.text =
              "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        scrollable: true,
        title: Text(widget.index == -1 ? "New Reading" : "Update Reading"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text("Weight"),
            TextField(
              controller: weightcontroller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Weight",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("kg"),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.none,
              onTap: () {
                selectDate();
              },
              controller: datecontroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Date",
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.none,
              controller: timecontroller,
              onTap: () {
                selectTime();
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Time",
                  prefixIcon: Icon(Icons.access_time)),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: notescontroller,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Notes",
                  prefixIcon: Icon(Icons.notes)),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () {
                    final WeightProvider value = context.read<WeightProvider>();

                    if (num.tryParse(weightcontroller.text) == null) {
                      const SnackBar invalidWeight = SnackBar(
                        content: Text("Enter a valid weight"),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(invalidWeight);
                    } else {
                      if (widget.index == -1) {
                        value.add(NewWeight(
                          weight: double.parse(weightcontroller.text),
                          date: datecontroller.text,
                          time: timecontroller.text,
                          notes: notescontroller.text,
                        ));
                        Navigator.of(context).pop();
                      } else {
                        NewWeight w = NewWeight(
                            weight: double.parse(weightcontroller.text),
                            date: datecontroller.text,
                            time: timecontroller.text,
                            notes: notescontroller.text);
                        value.update(widget.index, w);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(
                    widget.index == -1 ? "Save" : "Update",
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tracking_app/services/database_weight.dart';
import 'package:tracking_app/utils/loading.dart';

class MyAlertDialog extends StatefulWidget {
  final String uuid;
  const MyAlertDialog({super.key, this.uuid = ''});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController weightcontroller = TextEditingController();
  final TextEditingController notescontroller = TextEditingController();

  Future<void> defaultinitializer() async {
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

  Future<void> valueinitializer() async {
    final value = await DatabaseWeights().docValues(uuid: widget.uuid);

    weightcontroller.text = value.weight.toString();
    datecontroller.text = value.date;
    timecontroller.text = value.time;
    notescontroller.text = value.notes;
  }

  late Future<void> _docvalue;

  @override
  void initState() {
    if (widget.uuid == '') {
      _docvalue = defaultinitializer();
    } else {
      _docvalue = valueinitializer();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        scrollable: true,
        title: Text(widget.uuid == '' ? "New Reading" : "Update Reading"),
        content: FutureBuilder(
            future: _docvalue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ContentsOfAlertBox(
                    weightcontroller: weightcontroller,
                    datecontroller: datecontroller,
                    timecontroller: timecontroller,
                    notescontroller: notescontroller,
                    widget: widget);
              } else {
                return const Loading();
              }
            }),
      ),
    );
  }
}

class ContentsOfAlertBox extends StatefulWidget {
  const ContentsOfAlertBox({
    super.key,
    required this.weightcontroller,
    required this.datecontroller,
    required this.timecontroller,
    required this.notescontroller,
    required this.widget,
  });

  final TextEditingController weightcontroller;
  final TextEditingController datecontroller;
  final TextEditingController timecontroller;
  final TextEditingController notescontroller;
  final MyAlertDialog widget;

  @override
  State<ContentsOfAlertBox> createState() => _ContentsOfAlertBoxState();
}

class _ContentsOfAlertBoxState extends State<ContentsOfAlertBox> {
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
          widget.datecontroller.text = pickedDate;
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
          widget.timecontroller.text =
              "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
        }
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text("Weight"),
        TextField(
          controller: widget.weightcontroller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          controller: widget.datecontroller,
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
          controller: widget.timecontroller,
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
          controller: widget.notescontroller,
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
                if (num.tryParse(widget.weightcontroller.text) == null) {
                  const SnackBar invalidWeight = SnackBar(
                    content: Text("Enter a valid weight"),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(invalidWeight);
                } else {
                  if (widget.widget.uuid == '') {
                    DatabaseWeights().addWeights(
                        weight: double.parse(widget.weightcontroller.text),
                        date: widget.datecontroller.text,
                        time: widget.timecontroller.text,
                        notes: widget.notescontroller.text);
                    Navigator.of(context).pop();
                  } else {
                    DatabaseWeights().updatevalue(
                        uuid: widget.widget.uuid,
                        weight: double.parse(widget.weightcontroller.text),
                        date: widget.datecontroller.text,
                        time: widget.timecontroller.text,
                        notes: widget.notescontroller.text);
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text(
                widget.widget.uuid == '' ? "Save" : "Update",
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
    );
  }
}

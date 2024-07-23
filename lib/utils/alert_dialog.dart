import 'package:flutter/material.dart';

class MyAlertDialog extends StatefulWidget {
  final TextEditingController datecontroller;
  final TextEditingController timecontroller;
  final TextEditingController weightcontroller;
  final TextEditingController notescontroller;
  final VoidCallback addnewReading;
  const MyAlertDialog(
      {super.key,
      required this.datecontroller,
      required this.timecontroller,
      required this.weightcontroller,
      required this.notescontroller,
      required this.addnewReading,
      });

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
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

    return AlertDialog(
      title: const Text("New Reading"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text("Weight"),
          TextField(
            controller: widget.weightcontroller,
            keyboardType: TextInputType.number,
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
              ElevatedButton(
                onPressed: () {
                  widget.addnewReading();
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.purple.shade200),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.black),
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
    );
  }
}

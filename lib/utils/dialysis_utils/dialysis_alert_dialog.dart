import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/dialysisprovider.dart';
// import 'package:tracking_app/models/dialysis.dart';
import 'package:tracking_app/services/database_dialysis.dart';

class DialysisAlertDialog extends StatefulWidget {
  final String uuid;
  final String subuuid;
  const DialysisAlertDialog({super.key, this.uuid = "", this.subuuid = ""});

  @override
  State<DialysisAlertDialog> createState() => _DialysisAlertDialogState();
}

class _DialysisAlertDialogState extends State<DialysisAlertDialog> {
  final TextEditingController inmlcontroller = TextEditingController();
  final TextEditingController outmlcontroller = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController notescontroller = TextEditingController();

  void defaultInitializer() {
    DateTime now = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    String nowdate =
        "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}";
    datecontroller.text = nowdate;
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timecontroller.text = nowTime;
    inmlcontroller.clear();
    outmlcontroller.clear();
    notescontroller.clear();
  }

  void samedateInitailizer() {
    //TODO date
    // final DialysisProvier value =
    //     Provider.of<DialysisProvier>(context, listen: false);
    // datecontroller.text = value.items[widget.index].date;
    TimeOfDay time = TimeOfDay.now();
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timecontroller.text = nowTime;
    inmlcontroller.clear();
    outmlcontroller.clear();
    notescontroller.clear();
  }

  void editInitializer() {
    //TODO edit
    // final DialysisProvier value =
    //     Provider.of<DialysisProvier>(context, listen: false);
    // inmlcontroller.text =
    //     value.items[widget.index].session[widget.subindex].inml.toString();
    // outmlcontroller.text =
    //     value.items[widget.index].session[widget.subindex].outml.toString();
    // datecontroller.text =
    //     value.items[widget.index].session[widget.subindex].date;

    // timecontroller.text =
    //     value.items[widget.index].session[widget.subindex].time;
    // notescontroller.text =
    //     value.items[widget.index].session[widget.subindex].notes;
  }

  @override
  void initState() {
    if (widget.uuid == "" && widget.subuuid == "") {
      defaultInitializer();
    } else if (widget.uuid != "" && widget.subuuid == "") {
      samedateInitailizer();
    } else {
      editInitializer();
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
        title: widget.subuuid == ""
            ? const Text("New Session Reading")
            : const Text("Edit session reading"),
        scrollable: true,
        content: Column(
          children: [
            TextField(
              controller: inmlcontroller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "In",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("ml"),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: outmlcontroller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Out",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("ml"),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: datecontroller,
              keyboardType: TextInputType.none,
              onTap: () {
                selectDate();
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Date",
                  prefixIcon: Icon(Icons.calendar_today_rounded)),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: timecontroller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onTap: () {
                selectTime();
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Time",
                  prefixIcon: Icon(Icons.access_time)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: notescontroller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Notes",
                  prefixIcon: Icon(Icons.notes)),
            ),
          ],
        ),
        actions: [
          FilledButton(
              onPressed: () {
                // final value = context.read<DialysisProvier>();
                final inml = double.tryParse(inmlcontroller.text) ?? 0.0;
                final outml = double.tryParse(outmlcontroller.text) ?? 0.0;
                if (inml == 0.0 && outml == 0.0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please Enter atleast one valid input"),
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  if (widget.subuuid != "") {
                    //TODO update
                    // value.delete(
                    //     index: widget.index, subindex: widget.subindex);
                    // value.add(Onesession(
                    //     inml: inml,
                    //     outml: outml,
                    //     date: datecontroller.text,
                    //     time: timecontroller.text,
                    //     sessionnet: 0,
                    //     notes: notescontroller.text));
                  } else {
                    DatabaseDialysis().add(
                        inml: inml,
                        outml: outml,
                        date: datecontroller.text,
                        time: timecontroller.text,
                        notes: notescontroller.text);
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"))
        ],
      ),
    );
  }
}

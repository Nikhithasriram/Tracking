import 'package:flutter/material.dart';
import 'package:tracking_app/models/dialysisclass.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/Provider/dialysisprovider.dart';
// import 'package:tracking_app/models/dialysis.dart';
import 'package:tracking_app/services/database_dialysis.dart';
import 'package:tracking_app/utils/loading.dart';

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

  late Future<void> initializer;

  Future<void> defaultInitializer() async {
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

  Future<void> samedateInitailizer() async {
    //date
    // final DialysisProvier value =
    //     Provider.of<DialysisProvier>(context, listen: false);
    // datecontroller.text = value.items[widget.index].date;
    // try {
    //   final value = await DatabaseDialysis().pdreading(uuid: widget.uuid);
    // } catch (e) {
    //   print(e);
    // }
    final value = await DatabaseDialysis().pdreading(uuid: widget.uuid);
    // print(value?.date ?? "null");
    datecontroller.text = value?.date ?? "";
    TimeOfDay time = TimeOfDay.now();
    String min = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

    String nowTime =
        "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
    timecontroller.text = nowTime;
    inmlcontroller.clear();
    outmlcontroller.clear();
    notescontroller.clear();
  }

  Future<void> editInitializer() async {
    // print("edit initializer23");

    // try {
    //   final value = await DatabaseDialysis()
    //       .onesessionreading(uuid: widget.uuid, subuuid: widget.subuuid);
    // } catch (e) {
    //   print(e);
    // }
    final value = await DatabaseDialysis()
        .onesessionreading(uuid: widget.uuid, subuuid: widget.subuuid);
    // print("edit initializer");
    // print(value?.inml.toString() ?? "22222");
    inmlcontroller.text = value?.inml.toString() ?? "";
    outmlcontroller.text = value?.outml.toString() ?? "";
    datecontroller.text = value?.date.toString() ?? "";
    timecontroller.text = value?.time.toString() ?? "";
    notescontroller.text = value?.notes.toString() ?? "";
  }

  @override
  void initState() {
    if (widget.uuid == "" && widget.subuuid == "") {
      initializer = defaultInitializer();
    } else if (widget.uuid != "" && widget.subuuid == "") {
      initializer = samedateInitailizer();
    } else {
      initializer = editInitializer();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Content(
              widget: widget,
              inmlcontroller: inmlcontroller,
              outmlcontroller: outmlcontroller,
              datecontroller: datecontroller,
              timecontroller: timecontroller,
              notescontroller: notescontroller);
        } else {
          return const Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(content: Loading()));
        }
      },
      // child: Content(
      //     widget: widget,
      //     inmlcontroller: inmlcontroller,
      //     outmlcontroller: outmlcontroller,
      //     datecontroller: datecontroller,
      //     timecontroller: timecontroller,
      //     notescontroller: notescontroller),
    );
  }
}

class Content extends StatefulWidget {
  const Content({
    super.key,
    required this.widget,
    required this.inmlcontroller,
    required this.outmlcontroller,
    required this.datecontroller,
    required this.timecontroller,
    required this.notescontroller,
  });

  final DialysisAlertDialog widget;
  final TextEditingController inmlcontroller;
  final TextEditingController outmlcontroller;
  final TextEditingController datecontroller;
  final TextEditingController timecontroller;
  final TextEditingController notescontroller;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: widget.widget.subuuid == ""
            ? const Text("New Session Reading")
            : const Text("Edit session reading"),
        scrollable: true,
        content: Column(
          children: [
            TextField(
              controller: widget.inmlcontroller,
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
              controller: widget.outmlcontroller,
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
              controller: widget.datecontroller,
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
              controller: widget.timecontroller,
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
              controller: widget.notescontroller,
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
                final inml = double.tryParse(widget.inmlcontroller.text) ?? 0.0;
                final outml =
                    double.tryParse(widget.outmlcontroller.text) ?? 0.0;
                if (inml == 0.0 && outml == 0.0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please Enter atleast one valid input"),
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  if (widget.widget.subuuid != "") {
                    DatabaseDialysis().update(
                        uuid: widget.widget.uuid,
                        subuuid: widget.widget.subuuid,
                        reading: Onesession(
                            inml: inml,
                            outml: outml,
                            date: widget.datecontroller.text,
                            time: widget.timecontroller.text,
                            sessionnet: 0,
                            notes: widget.notescontroller.text,
                            uuid: widget.widget.subuuid));
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
                        date: widget.datecontroller.text,
                        time: widget.timecontroller.text,
                        notes: widget.notescontroller.text);
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

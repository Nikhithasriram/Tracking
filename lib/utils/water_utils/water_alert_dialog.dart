import 'package:flutter/material.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/services/database_water.dart';
import 'package:tracking_app/utils/loading.dart';
// import 'package:tracking_app/models/waterclass.dart';

class WaterAlertDialog extends StatefulWidget {
  final String uuid;
  final String subuuid;
  const WaterAlertDialog({super.key, this.uuid = '', this.subuuid = ''});

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

  late Future<void> _initializer;

  Future<void> defaultInitializer() async {
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

  Future<void> dateInitializer() async {
    // final value = Provider.of<WaterProvider>(context, listen: false);
    // dateController.text = value.items[widget.index].date;
    final DayWater value = await DatabaseWater().getwater(uuid: widget.uuid);
    dateController.text = value.date;
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

  Future<void> updateInitializer() async {
    final DayWater value = await DatabaseWater().getwater(uuid: widget.uuid);
    final content = value.dayContents.firstWhere((newwater) {
      return newwater.uuid == widget.subuuid;
    });
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

    dateController.text = value.date;
    timeController.text = content.time;
    notesController.text = content.notes;
  }

  @override
  void initState() {
    // print(widget.daycontentsindex);
    if (widget.uuid == '' && widget.subuuid == '') {
      // print("default");
      _initializer = defaultInitializer();
    } else if (widget.uuid != '' && widget.subuuid == '') {
      // print("date");
      _initializer = dateInitializer();
    } else if (widget.uuid != '' && widget.subuuid != '') {
      // print("eddit");
      _initializer = updateInitializer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ContentsAfterFuture(
                widget: widget,
                intakemlController: intakemlController,
                outputmlController: outputmlController,
                miscmlController: miscmlController,
                dateController: dateController,
                timeController: timeController,
                notesController: notesController);
          } else {
            return const Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
                content: Loading(),
              ),
            );
          }
        });
  }
}

class ContentsAfterFuture extends StatefulWidget {
  const ContentsAfterFuture({
    super.key,
    required this.widget,
    required this.intakemlController,
    required this.outputmlController,
    required this.miscmlController,
    required this.dateController,
    required this.timeController,
    required this.notesController,
  });

  final WaterAlertDialog widget;
  final TextEditingController intakemlController;
  final TextEditingController outputmlController;
  final TextEditingController miscmlController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController notesController;

  @override
  State<ContentsAfterFuture> createState() => _ContentsAfterFutureState();
}

class _ContentsAfterFutureState extends State<ContentsAfterFuture> {
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
        widget.dateController.text = pickedDate;
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
        widget.timeController.text =
            "${time.hourOfPeriod}:$min ${time.period.toString().split(".")[1]}";
      }
    });
  }

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        scrollable: true,
        title: Text(
            widget.widget.subuuid == '' ? "New Reading" : "Update Reading"),
        content: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (double.tryParse(value ?? "") == null && value != "") {
                    return "Enter valid value";
                  } else if (widget.intakemlController.text == "" &&
                      widget.outputmlController.text == "" &&
                      widget.miscmlController.text == "") {
                    return "Enter atlest one value";
                  }
                  return null;
                },
                controller: widget.intakemlController,
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
              TextFormField(
                validator: (value) {
                  if (double.tryParse(value ?? "") == null && value != "") {
                    return "Enter valid value";
                  } else if (widget.intakemlController.text == "" &&
                      widget.outputmlController.text == "" &&
                      widget.miscmlController.text == "") {
                    return "Enter atlest one value";
                  }
                  return null;
                },
                controller: widget.outputmlController,
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
              TextFormField(
                validator: (value) {
                  if (double.tryParse(value ?? "") == null && value != "") {
                    return "Enter valid value";
                  } else if (widget.intakemlController.text == "" &&
                      widget.outputmlController.text == "" &&
                      widget.miscmlController.text == "") {
                    return "Enter atlest one value";
                  }
                  return null;
                },
                controller: widget.miscmlController,
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
              TextFormField(
                onTap: () {
                  selectDate();
                },
                controller: widget.dateController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: "Date",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () {
                  selectTime();
                },
                controller: widget.timeController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.access_time),
                    hintText: "Time",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: widget.notesController,
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
        ),
        actions: [
          FilledButton(
            // style: ButtonStyle(
            //     backgroundColor:
            //         WidgetStatePropertyAll(Colors.purple.shade200)),
            onPressed: () {
              // final value = context.read<WaterProvider>();
               final double intakeml =
                  double.tryParse(widget.intakemlController.text) ?? 0.0;
              final double outputml =
                  double.tryParse(widget.outputmlController.text) ?? 0.0;
              final double miscml =
                  double.tryParse(widget.miscmlController.text) ?? 0.0;
              final String date = widget.dateController.text;
              final String time = widget.timeController.text;
              final String notes = widget.notesController.text;
              if (_formkey.currentState!.validate()) {
                // print("validates");
                if (widget.widget.subuuid == '') {
                  DatabaseWater().addWater(
                      intakeml: intakeml,
                      outputml: outputml,
                      miscml: miscml,
                      date: date,
                      time: time,
                      notes: notes);
                } else {
                  DatabaseWater().updatewater(
                      intakeml: intakeml,
                      outputml: outputml,
                      miscml: miscml,
                      date: date,
                      time: time,
                      notes: notes,
                      subuuid: widget.widget.subuuid);
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(
              widget.widget.subuuid == '' ? "Save" : "Update",
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

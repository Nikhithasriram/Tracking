import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/services/user.dart';
import 'package:intl/intl.dart';

void showUserDialog(BuildContext context) {
  final AppUser data = Provider.of<AppUser>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return UserAlerDialog(
        data: data,
      );
    },
  );
}

enum Gender { F, M, none }

class UserAlerDialog extends StatefulWidget {
  final AppUser data;
  const UserAlerDialog({super.key, required this.data});

  @override
  State<UserAlerDialog> createState() => _UserAlerDialogState();
}

class _UserAlerDialogState extends State<UserAlerDialog> {
  // late Future<AppUser> _data;
  late TextEditingController namecontroller = TextEditingController();
  late TextEditingController gendercontroller = TextEditingController();
  late TextEditingController dobcontroller = TextEditingController();
  late TextEditingController hospitalcontroller = TextEditingController();
  late TextEditingController doctorcontroller = TextEditingController();
  Gender? selectedvalue = Gender.none;

  @override
  void initState() {
    namecontroller.text = widget.data.name;
    dobcontroller.text = widget.data.dob != null
        ? DateFormat.yMMMd().format(widget.data.dob!)
        : "";
    hospitalcontroller.text = widget.data.hospital ?? "";
    doctorcontroller.text = widget.data.doctor ?? "";
    if (widget.data.gender == 'F') {
      selectedvalue = Gender.F;
    } else if (widget.data.gender == 'M') {
      selectedvalue = Gender.M;
    } else {
      selectedvalue = Gender.none;
    }
    super.initState();
  }

  DateTime? date;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit User Data"),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namecontroller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9\s.,!?@#\$%&*()-_+=:;'/\/]"))
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                  label: Text("Name"),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            const SizedBox(
              height: 15,
            ),
           Align(
            alignment: AlignmentGeometry.centerLeft,
             child: RadioGroup(
               groupValue: selectedvalue,
               onChanged: (Gender? value){
                 setState(() {
                   selectedvalue = value;
                 });
               }, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                 children: [
                   Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                      Radio(value: Gender.F),
                      Text("F"),
                      Radio(value: Gender.M),
                      Text("M"),
                      
                     ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                          Radio(value: Gender.none),
                          Text("Prefer not to say"),
                        ],
                  )
                 ],
               )),
           ),
            TextFormField(
              controller: dobcontroller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9\s.,!?@#\$%&*()-_+=:;'/\/]"))
              ],
              onTap: () async {
                date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (date != null) {
                  dobcontroller.text = DateFormat.yMMMd().format(date!);
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Date Of Birth",
                  label: Text("DOB"),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.calendar_today_rounded)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: doctorcontroller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9\s.,!?@#\$%&*()-_+=:;'/\/]"))
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Doctor Name",
                  label: Text("Doctor"),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: hospitalcontroller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9\s.,!?@#\$%&*()-_+=:;'/\/]"))
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Hospital Name",
                  label: Text("Hospital"),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        FilledButton(
            onPressed: () {
              String val;
              if (selectedvalue == Gender.F) {
                val = "F";
              } else if (selectedvalue == Gender.M) {
                val = "M";
              } else {
                val = "none";
              }
              // print(hospitalcontroller.text);
              // print(DateFormat.yMMMd().parse(dobcontroller.text));

              User().updateUser(
                  namecontroller.text,
                  DateFormat.yMMMd().tryParse(dobcontroller.text),
                  val,
                  hospitalcontroller.text,
                  doctorcontroller.text);
              Navigator.of(context).pop();
            },
            child: const Text("Save"))
      ],
    );
  }
}

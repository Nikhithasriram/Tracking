import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:tracking_app/utils/weight_utils/alert_dialog.dart';

 void createnewElement({  required BuildContext context,int index = -1}) {
    // print(context);
    showDialog(
        context: context,
        builder: (context) {
          return ScaffoldMessenger(
            child: MyAlertDialog(
              index: index,
            ),
          );
        });
  }
import 'package:flutter/material.dart';
import 'package:tracking_app/utils/weight_utils/alert_dialog.dart';

 void createnewElement({required BuildContext context,String uuid = ''}) {
    // print(context);
    showDialog(
        context: context,
        builder: (context) {
          return ScaffoldMessenger(
            child: MyAlertDialog(
              uuid: uuid,
            ),
          );
        });
  }
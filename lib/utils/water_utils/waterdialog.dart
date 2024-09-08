import 'package:flutter/material.dart';
import 'package:tracking_app/utils/water_utils/water_alert_dialog.dart';

void waterdialog({
  required BuildContext context,
  String uuid = '',
  String subuuid = '',
}) {
  showDialog(
      context: context,
      builder: (BuildContext dialogcontext) {
        return ScaffoldMessenger(
          child: WaterAlertDialog(
            uuid: uuid,
            subuuid: subuuid,
            dialogcontext: dialogcontext,
          ),
        );
      });
}

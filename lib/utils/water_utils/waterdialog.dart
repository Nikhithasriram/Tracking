import 'package:flutter/material.dart';
import 'package:tracking_app/utils/water_utils/water_alert_dialog.dart';

void waterdialog({
  required BuildContext context,
  int index = -1,
  int daycontents = -1,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: WaterAlertDialog(
            index: index,
            daycontentsindex: daycontents,
          ),
        );
      });
}

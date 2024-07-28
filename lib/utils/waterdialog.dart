import 'package:flutter/material.dart';
import 'package:tracking_app/utils/water_alert_dialog.dart';

void waterdialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const ScaffoldMessenger(
          child: WaterAlertDialog(),
        );
      });
}

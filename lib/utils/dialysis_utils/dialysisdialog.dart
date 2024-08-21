import 'package:flutter/material.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_alert_dialog.dart';

void dialysisdialog(
    {required BuildContext context, String uuid = "", String subuuid = ""}) {
  showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
            child: DialysisAlertDialog(
          uuid: uuid,
          subuuid: subuuid,
        ));
      });
}

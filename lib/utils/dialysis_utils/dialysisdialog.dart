import 'package:flutter/material.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_alert_dialog.dart';

void dialysisdialog(
    {required BuildContext context, int index = -1, int subindex = -1}) {
  showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
            child: DialysisAlertDialog(
          index: index,
          subindex: subindex,
        ));
      });
}

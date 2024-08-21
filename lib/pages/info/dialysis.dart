import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:tracking_app/models/dialysis.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_tile.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysisdialog.dart';

class DialysisPage extends StatelessWidget {
  const DialysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<List<DialysisReading>>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return DialysisTile(
            uuid: value[index].uuid,
            reading: value[index],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialysisdialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

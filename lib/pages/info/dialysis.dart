import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_tile.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysisdialog.dart';

class DialysisPage extends StatelessWidget {
  const DialysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Consumer<DialysisProvier>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.items.length,
            itemBuilder: (context, index) {
              return DialysisTile(
                index: index,
                reading: value.items[index],
              );
            },
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

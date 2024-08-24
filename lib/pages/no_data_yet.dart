import 'package:flutter/material.dart';

class NoDataYet extends StatelessWidget {
  const NoDataYet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Spacer(
          flex: 7,
        ),
        SizedBox(height: 200, width: 200, child: Image.asset('assets/add.png')),
        const Center(
          child: Column(
            children: [
              Text("No Data Yet"),
              Text("Press plus to add new reading"),
            ],
          ),
        ),
        const Spacer(
          flex: 10,
        ),
      ]),
    );
  }
}

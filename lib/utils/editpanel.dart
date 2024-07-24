import 'package:flutter/material.dart';
import 'package:tracking_app/utils/showdialog.dart';
import 'package:tracking_app/utils/confirmdelete.dart';

class EditPanel extends StatelessWidget {
  final int index;
  const EditPanel({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                createnewElement(context: context, index: index);
              },
              icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDelete(index: index);
                    });
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
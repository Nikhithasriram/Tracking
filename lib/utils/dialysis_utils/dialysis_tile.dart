import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/Provider/dialysisprovider.dart';
import 'package:tracking_app/models/dialysis.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysis_confirm_delete.dart';
import 'package:tracking_app/utils/dialysis_utils/dialysisdialog.dart';
import 'package:share_plus/share_plus.dart';

class DialysisTile extends StatelessWidget {
  final int index;
  final DialysisReading reading;
  const DialysisTile({super.key, required this.index, required this.reading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Net out: ${reading.netml} ml"),
        controlAffinity: ListTileControlAffinity.leading,
        // childrenPadding: const EdgeInsets.all(8),
        tilePadding: const EdgeInsets.only(left: 8, right: 4),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reading.date,
              style: const TextStyle(fontSize: 14),
            ),
            IconButton(
                onPressed: () {
                  dialysisdialog(context: context, index: index);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: reading.session
                      .map((r) => DialysisIndividualTile(
                            onesessionreadings: r,
                            subindex: reading.session.indexOf(r),
                            index: index,
                          ))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}

class DialysisIndividualTile extends StatelessWidget {
  final Onesession onesessionreadings;
  final int index;
  final int subindex;
  const DialysisIndividualTile(
      {super.key,
      required this.onesessionreadings,
      required this.subindex,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 3,
                color: Colors.purple.shade300,
              ),
            ),
            // const SizedBox(
            //   width: 4,
            // ),
            Text(
              (subindex + 1).toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      dense: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          onesessionreadings.inml != 0
              ? Text(
                  "In :${onesessionreadings.inml.toString()}ml",
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 8,
          ),
          onesessionreadings.outml != 0
              ? Text(
                  "Out :${onesessionreadings.outml.toString()}ml",
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
        ],
      ),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.only(left: 2, right: 2),
      subtitle: Text(onesessionreadings.notes),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                " net :${onesessionreadings.sessionnet.toString()} ml",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                onesessionreadings.time,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          DialysisMenu(
            index: index,
            subindex: subindex,
          )
        ],
      ),
    );
  }
}

class DialysisMenu extends StatelessWidget {
  final int index;
  final int subindex;
  const DialysisMenu({super.key, required this.index, required this.subindex});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert));
      },
      menuChildren: [
        IconButton(
            onPressed: () {
              dialysisdialog(
                  context: context, index: index, subindex: subindex);
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () async {
              final value = context
                  .read<DialysisProvier>()
                  .items[index]
                  .session[subindex];
              await Share.share(
                  "In: ${value.inml} \nOut: ${value.outml} \nNetout :${value.subnet} \nDate: ${value.date} \nTime: ${value.time}");
            },
            icon: const Icon(Icons.share)),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialysisConfirmDelete(
                      index: index, subindex: subindex);
                },
              );
            },
            icon: const Icon(Icons.delete))
      ],
    );
  }
}

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/functions/global_var.dart';

class WaterListTile extends StatefulWidget {
  final DayWater daily;
  final int index;
  const WaterListTile({super.key, required this.daily, required this.index});

  @override
  State<WaterListTile> createState() => _WaterListTileState();
}

class _WaterListTileState extends State<WaterListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 3),
          controlAffinity: ListTileControlAffinity.leading,
          key: Key(widget.index.toString()),
          initiallyExpanded: widget.index == waterselected,
          onExpansionChanged: (value) {
            waterselected = value ? widget.index : -1;
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Input: ${widget.daily.intakeml} ml"),
              Text("Output: ${widget.daily.outputml} ml"),
            ],
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.daily.date,
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
          childrenPadding: const EdgeInsets.all(10),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.daily.dayContents
                        .map((water) => IndividualListtile(water: water))
                        .toList(),
                  ),
                ),
              ),
            )
          ]
          // children: widget.daily.dayContents
          //     .map((water) => IndividualListtile(
          //           water: water,
          //         ))
          //     .toList(),
          ),
    );
  }
}

class IndividualListtile extends StatelessWidget {
  final NewWater water;
  const IndividualListtile({super.key, required this.water});

  @override
  Widget build(BuildContext context) {
    final String type = water.type == Watertype.intake
        ? "Intake"
        : water.type == Watertype.output
            ? "Output"
            : "Misc";
    return ExpansionTile(
      dense: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: 3,
          color: water.type == Watertype.intake
              ? Colors.blue
              : water.type == Watertype.output
                  ? Colors.amber
                  : Colors.grey,
        ),
      ),
      title: Text(
        "$type: ${water.value}ml",
        style: const TextStyle(fontSize: 15),
      ),
      subtitle: Text(water.notes),
      trailing: Text(
        water.time,
        style: const TextStyle(fontSize: 13),
      ),
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: const [WaterEditPannel()],
    );
  }
}

class WaterEditPannel extends StatelessWidget {
  const WaterEditPannel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
      ],
    );
  }
}

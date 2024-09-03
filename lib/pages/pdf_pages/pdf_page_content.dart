import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/models/graphselection.dart';
import 'package:tracking_app/pages/pdf_pages/selection_data.dart';
import 'package:tracking_app/utils/my_drawer.dart';

class PDFPage extends StatefulWidget {
  const PDFPage({super.key});

  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  final DateTime nowdate = DateTime.now();
  Selected selectedview = Selected.month;
  Set<Graphtype> graphveiw = {
    Graphtype.weight,
    Graphtype.waterIntake,
    Graphtype.waterOutput,
    Graphtype.dialysisOut
  };
  // late Uint8List _image;

  TextEditingController startcontroller = TextEditingController();
  TextEditingController endcontroller = TextEditingController();
  late DateTimeRange dateRange = DateTimeRange(
      start: DateTime(nowdate.year, nowdate.month - 1, nowdate.day),
      end: nowdate);
  @override
  Widget build(BuildContext context) {
    Future pickdateRange() async {
      DateTimeRange? newdateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(1990),
          lastDate: DateTime(2100),
          initialDateRange: dateRange);
      if (newdateRange == null) {
        return;
      } else {
        setState(() {
          dateRange = newdateRange;
          startcontroller.text = DateFormat.yMMMd().format(dateRange.start);
          endcontroller.text = DateFormat.yMMMd().format(dateRange.end);
        });
      }
    }

    startcontroller.text = DateFormat.yMMMd().format(dateRange.start);
    endcontroller.text = DateFormat.yMMMd().format(dateRange.end);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade50,
        title: const Text("PD Tracker"),
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      //TODO: drawer
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SegmentedButton(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                    selectedBackgroundColor:
                        const Color.fromARGB(255, 162, 177, 255)),
                segments: const [
                  ButtonSegment(
                    value: Selected.month,
                    label: Text("30 days"),
                  ),
                  ButtonSegment(
                    value: Selected.threemonths,
                    label: Text("90 days"),
                  ),
                  ButtonSegment(
                    value: Selected.year,
                    label: Text("365 days"),
                  ),
                  ButtonSegment(
                    value: Selected.custom,
                    label: Text("Custom"),
                  ),
                ],
                selected: {selectedview},
                onSelectionChanged: (Set<Selected> newselection) {
                  setState(() {
                    selectedview = newselection.first;
                  });
                },
              ),
              selectedview == Selected.custom
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 60,
                            child: TextField(
                              controller: startcontroller,
                              keyboardType: TextInputType.none,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                              onTap: () {
                                pickdateRange();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 100,
                            height: 60,
                            child: TextField(
                              controller: endcontroller,
                              keyboardType: TextInputType.none,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder()),
                              onTap: () {
                                pickdateRange();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Wrap(
                  spacing: 3,
                  children: Graphtype.values.map((Graphtype g) {
                    return FilterChip(
                        backgroundColor: Colors.blueGrey.shade50,
                        selectedColor: Colors.blue.shade200,
                        label: Text(g.name),
                        selected: graphveiw.contains(g),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              if (!graphveiw.contains(g)) {
                                graphveiw.add(g);
                                // print("remove");
                              }
                            } else {
                              if (graphveiw.contains(g)) {
                                graphveiw.remove(g);
                              }
                            }
                          });
                        });
                  }).toList(),
                ),
              ),
              // Container(
              //   child: _buildGraph(selectedview, dateRange.start, dateRange.end,
              //       Set.from(graphveiw)),
              // ),
              ElevatedButton(
                  onPressed: () {
                    selectionData(selectedview, dateRange.start, dateRange.end,
                        graphveiw);
                  },
                  child: const Text("Preview PDF"))
            ],
          ),
        ),
      ),
    );
  }
}

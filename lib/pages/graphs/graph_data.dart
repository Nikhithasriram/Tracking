import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:tracking_app/services/database_dialysis.dart';
import 'package:tracking_app/services/database_water.dart';
import 'package:tracking_app/services/database_weight.dart';
import 'package:tracking_app/utils/loading.dart';
import 'package:tracking_app/models/graphselection.dart';
import 'package:tracking_app/pages/graphs/graph.dart';
class GraphData extends StatefulWidget {
  final Selected option;
  final Set<Graphtype> graphveiw;
  final DateTime? startdate;
  final DateTime? enddate;
  const GraphData(
      {super.key,
      required this.option,
      required this.graphveiw,
      this.startdate,
      this.enddate});

  @override
  State<GraphData> createState() => _GraphDataState();
}

class _GraphDataState extends State<GraphData> {
  late Future getweightsfuture;
  List<NewWeight> weightvalue = [];
  List<DayWater> waterIntakeValue = [];
  List<DayWater> waterOutputValue = [];
  List<DialysisReading> dialysisValue = [];
  DateTime getdate(Selected option) {
    DateTime end = DateTime.now();
    if (option == Selected.month) {
      return DateTime(end.year, end.month - 1, end.day, end.hour);
    } else if (option == Selected.threemonths) {
      // print("3months");
      return DateTime(end.year, end.month - 3, end.day, end.hour);
    } else if (option == Selected.year) {
      return DateTime(end.year - 1, end.month, end.day, end.hour);
    } else {
      return DateTime.now();
    }
  }

  Future<void> getdata() async {
    weightvalue = [];
    waterIntakeValue = [];
    waterOutputValue = [];
    dialysisValue = [];
    DateTime end = DateTime.now();
    if (widget.startdate == null && widget.enddate == null) {
      if (widget.graphveiw.contains(Graphtype.weight)) {
        weightvalue = await DatabaseWeights()
            .weightBetweenDates(getdate(widget.option), end);
      }
      if (widget.graphveiw.contains(Graphtype.waterIntake)) {
        waterIntakeValue = await DatabaseWater()
            .waterBetweenDates(getdate(widget.option), end);
      }
      if (widget.graphveiw.contains(Graphtype.waterOutput)) {
        waterOutputValue = await DatabaseWater()
            .waterBetweenDates(getdate(widget.option), end);
      }
      if (widget.graphveiw.contains(Graphtype.dialysisOut)) {
        dialysisValue = await DatabaseDialysis()
            .dialysisReadingBetweenDates(getdate(widget.option), end);
      }
    }
    if (widget.startdate != null && widget.enddate != null) {
      // print("custom");
      weightvalue = await DatabaseWeights()
          .weightBetweenDates(widget.startdate!, widget.enddate!);
    }
  }

  @override
  void initState() {
    getweightsfuture = getdata();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.option != widget.option) {
      setState(() {
        getweightsfuture = getdata();
      });
    }
    if (oldWidget.startdate != widget.startdate ||
        oldWidget.enddate != widget.enddate) {
      setState(() {
        getweightsfuture = getdata();
      });
    }
    if (!setEquals(oldWidget.graphveiw, widget.graphveiw)) {
      setState(() {
        getweightsfuture = getdata();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.graphveiw);
    return FutureBuilder(
      future: getweightsfuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Graph(
              weightvalue: weightvalue,
              waterIntakeValue: waterIntakeValue,
              waterOutputValue: waterOutputValue,
              dialysisValue: dialysisValue);
        } else {
          return const Center(child: Loading());
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/dialysisclass.dart';
import 'package:tracking_app/models/waterclass.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  final List<NewWeight> weightvalue;
  final List<DayWater> waterIntakeValue;
  final List<DayWater> waterOutputValue;
  final List<DialysisReading> dialysisValue;

  const Graph(
      {super.key,
      required this.weightvalue,
      required this.waterIntakeValue,
      required this.waterOutputValue,
      required this.dialysisValue});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    // print(widget.weightvalue.length);
    // print(widget.waterIntakeValue.length);
    // print(widget.waterOutputValue.length);
    // print(widget.dialysisValue.length);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 350,
            width: MediaQuery.of(context).size.width - 10,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: SfCartesianChart(
                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true, enablePinching: true),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat.yMMMd(),
                    title: const AxisTitle(text: "Date"),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryYAxis: const NumericAxis(
                    labelStyle: TextStyle(),
                    title: AxisTitle(
                        text: "Volume(ml)", textStyle: TextStyle(fontSize: 15)),
                  ),
                  axes: const [
                    NumericAxis(
                      name: 'weightAxis',
                      title: AxisTitle(text: "Weight(kg)"),
                      opposedPosition: true,
                    )
                  ],
                  legend: const Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: lineseries(
                      widget.weightvalue,
                      widget.waterIntakeValue,
                      widget.waterOutputValue,
                      widget.dialysisValue)),
            )),
          ),
        ),
      ),
    );
  }
}

List<CartesianSeries> lineseries(
    List<NewWeight> weightvalue,
    List<DayWater> waterIntakeValue,
    List<DayWater> waterOutputValue,
    List<DialysisReading> dialysisValue) {
  List<CartesianSeries> value = [];
  if (weightvalue.isNotEmpty) {
    // print(weightvalue.length);
    value.add(LineSeries<NewWeight, DateTime>(
        markerSettings: const MarkerSettings(isVisible: true),
        enableTooltip: true,
        name: "Weight",
        yAxisName: 'weightAxis',
        // xAxisName: "Date",
        // yAxisName: "Weight",
        dataSource: weightvalue,
        xValueMapper: (NewWeight data, _) => mydatetime(data.date, data.time),
        yValueMapper: (NewWeight data, _) => data.weight.round()));
  }
  if (waterIntakeValue.isNotEmpty) {
    // print(waterIntakeValue.length);
    value.add(LineSeries<DayWater, DateTime>(
        markerSettings: const MarkerSettings(isVisible: true),
        enableTooltip: true,
        name: "Water Input",
        // xAxisName: "Date",
        // yAxisName: "Weight",
        dataSource: waterIntakeValue,
        xValueMapper: (DayWater data, _) => mydatetime(data.date, "5:00 pm"),
        yValueMapper: (DayWater data, _) => data.intakeml.round()));
  }
  if (waterOutputValue.isNotEmpty) {
    // print(waterOutputValue.length);
    value.add(LineSeries<DayWater, DateTime>(
        markerSettings: const MarkerSettings(isVisible: true),
        enableTooltip: true,
        name: "Water Output",
        // xAxisName: "Date",
        // yAxisName: "Weight",
        dataSource: waterOutputValue,
        xValueMapper: (DayWater data, _) => mydatetime(data.date, "5:00 pm"),
        yValueMapper: (DayWater data, _) => data.outputml.round()));
  }
  if (dialysisValue.isNotEmpty) {
    // print(dialysisValue);
    value.add(LineSeries<DialysisReading, DateTime>(
        markerSettings: const MarkerSettings(isVisible: true),
        enableTooltip: true,
        name: "PD NetOut",
        // xAxisName: "Date",
        // yAxisName: "Weight",
        dataSource: dialysisValue,
        xValueMapper: (DialysisReading data, _) =>
            mydatetime(data.date, "5:00 pm"),
        yValueMapper: (DialysisReading data, _) => data.netml.round()));
  }
  // print("----------------------------------------------");
  // print(value);
  return value;
}
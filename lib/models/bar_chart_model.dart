import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String? name;
  int? percent;
  final charts.Color? color;

  BarChartModel({this.name,
    this.percent,
    this.color,}
      );
}
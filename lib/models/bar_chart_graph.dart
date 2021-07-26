import 'package:flutter/material.dart';

import 'bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class BarChartGraph extends StatelessWidget{
final List<BarChartModel> data;
BarChartGraph(this.data);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: data,
          domainFn: (BarChartModel series, _) => series.name!,
          measureFn: (BarChartModel series, _) => series.percent!,
          colorFn: (BarChartModel series, _) => series.color!),
    ];
    return Expanded(child: charts.BarChart(series,animate: true,));
  }

 /* Widget _buildFinancialList(series) {
    return _barChartList != null
        ? ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
        height: 5,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _barChartList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: MediaQuery.of(context).size.height/ 2.3,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_barChartList[index].month,
                      style: TextStyle(
                          color: Colors.black, fontSize: 22,
                          fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              Expanded( child: charts.BarChart(series,
                  animate: true)
              ),
            ],
          ),
        );
      },
    )
        : SizedBox();
  }*/

}
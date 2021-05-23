import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';

class PopulationData {
  int year;
  String month;
  int population;
  charts.Color barColor;
  PopulationData({
    this.year,
    @required this.population,
    @required this.barColor,
    @required this.month
  });
}
final List<PopulationData> data = [
  PopulationData(
      month: 'Mar 1',
      population: 0,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 2',
      population: 200,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 3',
      population: 400,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 4',
      population: 600,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 5',
      population: 800,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 6',
      population: 1000,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 7',
      population: 1200,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 8',
      population: 1400,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 9',
      population: 1600,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 10',
      population: 1800,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 11',
      population: 2000,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 12',
      population: 2200,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 13',
      population: 2400,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 14',
      population: 2600,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue)
  ),
  PopulationData(
      month: 'Mar 15',
      population: 2800,
      barColor: charts.ColorUtil.fromDartColor(MyColors.barBlue),
  ),
];

class Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      width: 800,
      padding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              MyStrings.cumulative,
              style: MyStyles.robotoMedium26.copyWith( color: MyColors.accentsColors, fontWeight: FontWeight.w100),

            ),
            SizedBox(height: 20,),
            Expanded(
              child: charts.BarChart(
                _getSeriesData(),
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(labelRotation: 45,
                      labelAnchor: charts.TickLabelAnchor.after,)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


_getSeriesData() {
  List<charts.Series<PopulationData, String>> series = [
    charts.Series(
        id: "Population",
        data: data,
        domainFn: (PopulationData series, _) => series.month,
        measureFn: (PopulationData series, _) => series.population,
        colorFn: (PopulationData series, _) => series.barColor
    )
  ];
  return series;
}
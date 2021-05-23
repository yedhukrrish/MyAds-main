import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';

import 'Chart.dart';
import 'CheckMyCoupons.dart';
import 'settings/SettingScreen.dart';

class ChartsDemo extends StatefulWidget {
  //
  ChartsDemo() : super();

  final String title = "Charts Demo";

  @override
  ChartsDemoState createState() => ChartsDemoState();
}

class ChartsDemoState extends State<ChartsDemo> {
  //
  List<charts.Series> seriesList;

  static List<charts.Series<Sales, String>> _createRandomData() {
    final random = Random();

    final tabletSalesData = [
      Sales('1-Mar', 200),
      Sales('2-Mar', 180),
      Sales('3-Mar', 160),
      Sales('4-Mar', 140),
      Sales('5-Mar', 120),
      Sales('6-Mar', 100),
      Sales('7-Mar', 80),
      Sales('8-Mar', 60),
      Sales('9-Mar', 40),
      Sales('10-Mar', 20),
      Sales('11-Mar', 80),
      Sales('12-Mar', 60),
      Sales('13-Mar', 40),
      Sales('14-Mar', 20),
      Sales('15-Mar', 20),
      // Sales('15-Mar', random.nextInt(100)),
    ];

    final mobileSalesData = [
      Sales('1-Mar', 100),
      Sales('2-Mar', 80),
      Sales('3-Mar', 160),
      Sales('4-Mar', 140),
      Sales('5-Mar', 200),
      Sales('6-Mar', 100),
      Sales('7-Mar', 80),
      Sales('8-Mar', 60),
      Sales('9-Mar', 40),
      Sales('10-Mar', 20),
      Sales('11-Mar', 80),
      Sales('12-Mar', 60),
      Sales('13-Mar', 40),
      Sales('14-Mar', 20),
      Sales('15-Mar', 20),
      // Sales('15-Mar', random.nextInt(100)),
    ];

    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: tabletSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.ColorUtil.fromDartColor(MyColors.orange);
        },
      ),
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: mobileSalesData,
        fillColorFn: (Sales sales, _) {
          return charts.ColorUtil.fromDartColor(MyColors.blue);
        },
      )
    ];
  }

  // barChart() {
  //   return charts.BarChart(
  //     seriesList,
  //     animate: true,
  //     vertical: true,
  //
  //     barGroupingType: charts.BarGroupingType.grouped,
  //     defaultRenderer: charts.BarRendererConfig(
  //       groupingType: charts.BarGroupingType.grouped,
  //       strokeWidthPx: 1.0,
  //     ),
  //     domainAxis: charts.OrdinalAxisSpec(
  //       renderSpec: charts.NoneRenderSpec(),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.colorLight,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(''),
            Padding(
              padding: const EdgeInsets.only(left: 26.0),
              child: Image.asset(MyImages.appBarLogo),
            ),
            _DividerPopMenu(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Center(
                child: Text(
                  MyStrings.graphs,
                  style: MyStyles.robotoMedium30.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.accentsColors,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: MyColors.accentsColors,
              thickness: 2.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Text(
                  MyStrings.dailyViewingTime,
                  style: MyStyles.robotoMedium26.copyWith(
                      color: MyColors.accentsColors,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Container(
              height: 400.0,
              padding: EdgeInsets.all(10.0),
              child: StackedFillColorBarChart(seriesList),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 15.0,
                        width: 15.0,
                        color: MyColors.blue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Minutes per day',
                        style: MyStyles.robotoMedium12.copyWith(
                            letterSpacing: 1.0,
                            color: MyColors.black,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15.0,
                        width: 15.0,
                        color: MyColors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Bonus Minutes',
                        style: MyStyles.robotoMedium12.copyWith(
                            letterSpacing: 1.0,
                            color: MyColors.black,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 10.0,
              color: MyColors.accentsColors,
              thickness: 2.0,
            ),
            Container(
              height: 400.0,
              padding: EdgeInsets.all(10.0),
              child: Charts(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()));
              },
              child: _submitButton(MyStrings.returnTo),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}

Widget _submitButton(String buttonName) {
  return Container(
    width: 250.0,
    height: 45.0,
    padding: EdgeInsets.symmetric(vertical: 13),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.blueAccent.withAlpha(100),
              offset: Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 1)
        ],
        color: MyColors.primaryColor),
    child: Text(
      buttonName,
      style: MyStyles.robotoMedium14.copyWith(
          letterSpacing: 3.0,
          color: MyColors.white,
          fontWeight: FontWeight.w500),
    ),
  );
}

/// Example of a stacked bar chart with three series, each rendered with
/// different fill colors.
class StackedFillColorBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedFillColorBarChart(this.seriesList, {this.animate});

  factory StackedFillColorBarChart.withSampleData() {
    return new StackedFillColorBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 2.0),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: -90,
          labelAnchor: charts.TickLabelAnchor.before,
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('1-Mar', 5),
      new OrdinalSales('2-Mar', 25),
      new OrdinalSales('3-Mar', 85),
      new OrdinalSales('4-Mar', 75),
      new OrdinalSales('5-Mar', 75),
      new OrdinalSales('6-Mar', 75),
      new OrdinalSales('7-Mar', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('1-Mar', 25),
      new OrdinalSales('2-Mar', 50),
      new OrdinalSales('3-Mar', 10),
      new OrdinalSales('4-Mar', 20),
      new OrdinalSales('5-Mar', 20),
      new OrdinalSales('6-Mar', 20),
      new OrdinalSales('7-Mar', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('1-Mar', 10),
      new OrdinalSales('2-Mar', 50),
      new OrdinalSales('3-Mar', 50),
      new OrdinalSales('4-Mar', 45),
      new OrdinalSales('5-Mar', 45),
      new OrdinalSales('6-Mar', 45),
      new OrdinalSales('7-Mar', 45),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

Widget _DividerPopMenu() {
  return new PopupMenuButton<String>(
      offset: const Offset(0, 30),
      color: MyColors.blueShade,
      icon: const Icon(
        Icons.menu,
        color: MyColors.accentsColors,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            new PopupMenuItem<String>(
                value: 'value01',
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new DashBoardScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dashboard                  ',
                        style: MyStyles.robotoMedium16.copyWith(
                            letterSpacing: 1.0,
                            color: MyColors.black,
                            fontWeight: FontWeight.w100),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: MyColors.darkGray,
                      )
                    ],
                  ),
                )),
            new PopupMenuDivider(height: 3.0),
            new PopupMenuItem<String>(
                value: 'value02',
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new SettingScreen()));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SettingScreen()));
                    },
                    child: new Text(
                      'Settings',
                      style: MyStyles.robotoMedium16.copyWith(
                          letterSpacing: 1.0,
                          color: MyColors.black,
                          fontWeight: FontWeight.w100),
                    ))),
            new PopupMenuDivider(height: 3.0),
            new PopupMenuItem<String>(
                value: 'value03',
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new MyCouponScreen()));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MyCouponScreen()));
                    },
                    child: new Text(
                      'Gift Card',
                      style: MyStyles.robotoMedium16.copyWith(
                          letterSpacing: 1.0,
                          color: MyColors.black,
                          fontWeight: FontWeight.w100),
                    ))),
            new PopupMenuDivider(height: 3.0),
            new PopupMenuItem<String>(
                value: 'value04',
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new ChartsDemo()));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ChartsDemo()));
                  },
                  child: new Text(
                    'Graphs',
                    style: MyStyles.robotoMedium16.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ))
          ],
      onSelected: (String value) {
        // setState(() { _bodyStr = value; });
      });
}

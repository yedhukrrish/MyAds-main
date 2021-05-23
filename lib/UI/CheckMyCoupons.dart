import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';
import 'package:myads_app/UI/settings/SettingScreen.dart';

import 'BarChart.dart';

class MyCouponScreen extends StatefulWidget {
  @override
  _MyCouponScreenState createState() => _MyCouponScreenState();
}

class Coupons {
  Coupons({
    this.date,
    this.couponType,
    this.status,
  });

  final String date;
  final String couponType;
  final String status;
}

class _MyCouponScreenState extends State<MyCouponScreen> {
  List<Coupons> myCoupons = <Coupons>[
    Coupons(
        date: '1st March 2021',
        couponType: 'Netflix Gift Card',
        status: 'Pending'),
    Coupons(
        date: '1st April 2021',
        couponType: 'Netflix Gift Card',
        status: 'Generated'),
    Coupons(
        date: '1st June 2021',
        couponType: 'Disney+ Gift Card',
        status: 'Generated'),
    Coupons(
        date: '1st June 2021',
        couponType: 'Netflix Gift Card',
        status: 'Generated'),
    Coupons(
        date: '1st July 2021',
        couponType: 'Netflix Gift Card',
        status: 'Generated'),
    Coupons(
        date: '1st July 2021',
        couponType: 'Netflix Gift Card',
        status: 'Generated'),
    Coupons(
        date: '1st October 2021',
        couponType: 'Netflix Gift Card',
        status: 'Pending'),
    Coupons(
        date: '1st October 2021',
        couponType: 'Netflix Gift Card',
        status: 'Pending'),
  ];
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
              child: Center(
                child: Text(
                  MyStrings.yourSettings,
                  style: MyStyles.robotoLight28.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: MyColors.accentsColors,
              thickness: 2.0,
            ),
            DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      '',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                    ),
                  ),
                ],
                columnSpacing: 20.0,
                headingRowHeight: 0,
                rows: myCoupons != null
                    ? List.generate(
                        myCoupons.length,
                        (index) => DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                return index % 2 == 0
                                    ? MyColors.colorLight
                                    : Colors.white;
                              }),
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    myCoupons[index].date,
                                    style: MyStyles.robotoMedium14.copyWith(
                                        color: MyColors.lightGray,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    myCoupons[index].couponType,
                                    style: MyStyles.robotoMedium14.copyWith(
                                        color: MyColors.black,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                DataCell(Text(
                                  myCoupons[index].status,
                                  style: MyStyles.robotoMedium14.copyWith(
                                      color: MyColors.lightGray,
                                      fontWeight: FontWeight.w100),
                                )),
                                DataCell(
                                  Image.asset(
                                    MyImages.copyIcon,
                                  ),
                                ),
                              ],
                            ))
                    : SizedBox()),
            Divider(height: 10.0, color: MyColors.lightGray),
            SizedBox(
              height: 30.0,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new SettingScreen()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                child: _submitButton('RETURN TO SETTINGS')),
          ],
        ),
      ),
    );
  }
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

Widget _submitButton(String buttonName) {
  return Container(
    width: 280.0,
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

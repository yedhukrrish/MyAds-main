import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';

import 'BarChart.dart';
import 'CheckMyCoupons.dart';
import 'settings/SettingScreen.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: MyColors.white,
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
              padding: const EdgeInsets.only(top:30.0),
              child: Center(
                child: Text(MyStrings.congratulations,
                  style: MyStyles.robotoLight28.copyWith(letterSpacing: 1.0, color: MyColors.primaryColor, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Center(
                child: Text(MyStrings.youHaveAchieved,
                  style: MyStyles.robotoLight22.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Center(
              child: Text(MyStrings.multiplier,
                style: MyStyles.robotoBold28.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(height: 5.0,),
            Center(
              child: Text(MyStrings.goldShield,
                style: MyStyles.robotoLight22.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(height: 20.0,),
            Stack(
              children: [
                Image.asset(MyImages.goldShield),
                Padding(
                  padding: const EdgeInsets.only(top:90.0, left: 80.0),
                  child: Text(MyStrings.percent10,
                    style: MyStyles.robotoMedium60.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:160.0, left: 80.0),
                  child: Text(MyStrings.multipliers,
                    style: MyStyles.robotoMedium26.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Center(
                child: Text(MyStrings.yourWatch,
                  style: MyStyles.robotoLight22.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Center(
                child: Text(MyStrings.moreForNext,
                  style: MyStyles.robotoLight22.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Center(
                child: Text(MyStrings.keepItUp,
                  style: MyStyles.robotoLight22.copyWith(letterSpacing: 1.0, color: MyColors.accentsColors, fontWeight: FontWeight.w100),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
                },
                child: _submitButton(MyStrings.returnTo)),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard                  ',
                  style: MyStyles.robotoMedium16.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.lightGray,
                      fontWeight: FontWeight.w100),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: MyColors.darkGray,
                )
              ],
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
      style: MyStyles.robotoMedium14.copyWith(letterSpacing: 3.0, color: MyColors.white, fontWeight: FontWeight.w500),

    ),
  );
}
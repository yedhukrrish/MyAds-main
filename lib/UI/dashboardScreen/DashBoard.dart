import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/RewardScreen.dart';
import 'package:myads_app/UI/Widgets/progressbar.dart';
import 'package:myads_app/UI/dashboardScreen/videoPlayer.dart';
import 'package:myads_app/UI/portraitScreen/watchPortraitScreen.dart';
import 'package:myads_app/UI/settings/SettingScreen.dart';
import 'package:myads_app/UI/welcomeScreen/welcomeScreen.dart';
import 'package:myads_app/base/base_state.dart';
import 'package:myads_app/model/response/dashboard/getVideosResponse.dart';
import 'package:myads_app/utils/code_snippet.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../BarChart.dart';
import '../CheckMyCoupons.dart';
import 'dashboardProvider.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends BaseState<DashBoardScreen> {
  DashboardProvider _dashboardProvider;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    _dashboardProvider.listener = this;
    _dashboardProvider.performGetVideos();
  }

  String videoUrl, watchTime = '0.0', daysLeft = '0.0', Videoid, per,producturl;
  double percentage = 0.0;
  BuildContext subcontext;
  @override
  void onSuccess(any, {int reqId}) {
    ProgressBar.instance.hideProgressBar();
    super.onSuccess(any);
    print("in on sucess");
    switch (reqId) {
      case ResponseIds.GET_VIDEO:
        VideoResponse _response = any as VideoResponse;
        print("ResponseDAW" + _response.toString());
        if (_response.userId.isNotEmpty) {
          print("success ${_response.videoLink}");
          setState(() {
            int thours, tmins, tsecs, secs, hours, mins, BalanceTime;
            String BalTimeHours, BalTimeMins, BalTimeSecs;
            String s1 = _response.watchedtime;
            String s2 = _response.toWatchtime;
            thours = int.parse((s1.split(":"))[0]);
            tmins = int.parse((s1.split(":"))[1]);
            tsecs = int.parse((s1.split(":"))[2]);
            hours = int.parse((s2.split(":"))[0]);
            mins = int.parse((s2.split(":"))[1]);
            secs = int.parse((s2.split(":"))[2]);
            BalanceTime = (hours * 60 + mins) * 60 - (thours * 60 + tmins) * 60;
            BalanceTime = BalanceTime % (24 * 3600);
            BalTimeHours = (BalanceTime ~/ 3600).toString();
            BalanceTime = BalanceTime % (3600);
            BalTimeMins = (BalanceTime ~/ 60).toString();
            BalTimeSecs = (BalanceTime % (60)).toString();
            print(BalTimeHours + ":" + BalTimeMins + ":" + BalTimeSecs);
            if (BalTimeHours.length < 2) {
              BalTimeHours = "0" + BalTimeHours;
            }
            if (BalTimeMins.length < 2) {
              BalTimeMins = "0" + BalTimeMins;
            }
            if (BalTimeSecs.length < 2) {
              BalTimeSecs = "0" + BalTimeSecs;
            }
            videoUrl = _response.videoLink;
            watchTime = BalTimeHours + ":" + BalTimeMins + ":" + BalTimeSecs;
            percentage = double.parse(_response.wtachedPercentage) / 1000;
            per = _response.wtachedPercentage;
            daysLeft = _response.daysLeftThisMonth.toString();
            Videoid = _response.videoId;
            producturl=_response.productURL;
          });
          // print("Signup res username ${SharedPrefManager.instance.getString(Constants.userName)}");
        } else {
          print("failure");
          CodeSnippet.instance.showMsg(_response.userId);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
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
          child: Consumer<DashboardProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Text(
                  MyStrings.yourDashBoard,
                  style: MyStyles.robotoMedium28.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.accentsColors,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 3,
                    color: MyColors.accentsColors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '$watchTime',
                          style: MyStyles.robotoLight24.copyWith(
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                        Text(
                          'yet to watch',
                          style: MyStyles.robotoLight12.copyWith(
                              color: MyColors.colorLight,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 3,
                    color: MyColors.primaryColor,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularPercentIndicator(
                        radius: 75.0,
                        lineWidth: 5.0,
                        backgroundColor: MyColors.accentsColors,
                        animation: true,
                        percent: percentage,
                        center: new Text(
                          "${per.toString()}%",
                          style: MyStyles.robotoMedium20.copyWith(
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: new Text(
                            "monthly progress",
                            style: MyStyles.robotoLight12.copyWith(
                                color: MyColors.white,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                        // circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.white,
                      ),
                    )),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 3,
                    color: MyColors.accentsColors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '$daysLeft',
                          style: MyStyles.robotoLight62.copyWith(
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                        Text(
                          'days left in month',
                          style: MyStyles.robotoLight12.copyWith(
                              color: MyColors.colorLight,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            videoUrl == null || videoUrl == ''
                ? CircularProgressIndicator()
                : DashboardVideo(
                    videoUrl: videoUrl,
                    id: Videoid,
                    watchTime: watchTime,
                    productUrl: producturl,
                  ),
            SizedBox(height: 10),
            Stack(
              children: <Widget>[
                //First thing in the stack is the background
                //For the backgroud i create a column
                Column(
                  children: <Widget>[
                    //first element in the column is the white background (the Image.asset in your case)
                    Container(
                      color: MyColors.lightBlueShade,
                      width: MediaQuery.of(context).size.width,
                      height: 140.0,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => new WatchPortrait(
                                    videoUrl: videoUrl, VideoId: Videoid,watchtime: watchTime,productUrl: producturl)));
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => WatchPortrait()));
                          },
                          child: Center(child: _submitButton('WATCH MYADS'))),
                    ),
                    //second item in the column is a transparent space of 20
                    Container(height: 10.0)
                  ],
                ),
                //for the button i create another column
                Column(children: <Widget>[
                  //first element in column is the transparent offset
                  Container(height: 100.0),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new RewardsScreen()));
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RewardsScreen()));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70.0,
                                      child: Image.asset(MyImages.goldIcon),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(19.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '100',
                                            style: MyStyles.robotoBold14
                                                .copyWith(
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                          Text(
                                            'minutes',
                                            style: MyStyles.robotoMedium8
                                                .copyWith(
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new RewardsScreen()));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70.0,
                                      child: Image.asset(MyImages.goldIcon),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '500',
                                            style: MyStyles.robotoBold14
                                                .copyWith(
                                                    letterSpacing: 1.0,
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                          Text(
                                            "minutes",
                                            style: MyStyles.robotoMedium8
                                                .copyWith(
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          new RewardsScreen()));
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70.0,
                                      child: Image.asset(MyImages.goldIcon),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '1000',
                                            style: MyStyles.robotoBold14
                                                .copyWith(
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                          Text(
                                            'minutes',
                                            style: MyStyles.robotoMedium8
                                                .copyWith(
                                                    color:
                                                        MyColors.accentsColors,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new RewardsScreen()));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70.0,
                                  child: Image.asset(MyImages.goldShield),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        MyStrings.percent10,
                                        style: MyStyles.robotoBold14.copyWith(
                                            color: MyColors.accentsColors,
                                            fontWeight: FontWeight.w100),
                                      ),
                                      Text(
                                        MyStrings.multipliers,
                                        style: MyStyles.robotoMedium8.copyWith(
                                            color: MyColors.accentsColors,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ])
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new SettingScreen()));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
                    },
                    child: _submitButton1('SETTINGS')),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new ChartsDemo()));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChartsDemo()));
                    },
                    child: _submitButton1('GRAPHS')),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        );
      })),
    );
  }

  Widget _DividerPopMenu() {
    return new PopupMenuButton<String>(
        offset: const Offset(0, 30),
        color: MyColors.blueShade,
        icon: const Icon(
          Icons.menu,
          color: MyColors.accentsColors,
        ),
        itemBuilder: (BuildContext context) {
          subcontext = context;
          return <PopupMenuEntry<String>>[
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
                )),
            new PopupMenuDivider(height: 3.0),
            new PopupMenuItem<String>(
                value: 'value05',
                child: InkWell(
                  onTap: () async {
                    await SharedPrefManager.instance
                        .setString(Constants.userEmail, null)
                        .whenComplete(() => print(
                        "user logged out . set to null"));
                    await SharedPrefManager.instance
                        .setString(Constants.password, null)
                        .whenComplete(() => print(
                        "user logged out . set to null"));
                    Navigator.of(subcontext).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new WelcomeScreen()));

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ChartsDemo()));
                  },
                  child: new Text(
                    'Logout',
                    style: MyStyles.robotoMedium16.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.black,
                        fontWeight: FontWeight.w100),
                  ),
                ))
          ];
        },
        onSelected: (String value) {
          if (value == 'value02') {
            Navigator.of(subcontext).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new SettingScreen()));
          } else if (value == 'value03') {
            Navigator.of(subcontext).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new MyCouponScreen()));
          } else if (value == 'value04') {
            Navigator.of(subcontext).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ChartsDemo()));
          }
          else if (value == 'value05') {
            Navigator.of(subcontext).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new WelcomeScreen()));
          }
        });
  }
}

Widget _submitButton(String buttonName) {
  return Container(
    width: 190.0,
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
    child: Align(
      alignment: Alignment.center,
      child: Text(
        buttonName,
        style: MyStyles.robotoMedium12.copyWith(
            letterSpacing: 4.0,
            color: MyColors.white,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

Widget _submitButton1(String buttonName) {
  return Container(
    width: 100.0,
    height: 40.0,
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
    child: Align(
      alignment: Alignment.center,
      child: Text(
        buttonName,
        style: MyStyles.robotoMedium12.copyWith(
            letterSpacing: 4.0,
            color: MyColors.white,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

class ProgressIndicator extends StatefulWidget {
  ProgressIndicator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 5.0,
            backgroundColor: MyColors.accentsColors,
            animation: true,
            percent: 0.25,
            center: new Text(
              "25%",
              style: MyStyles.robotoMedium22
                  .copyWith(color: MyColors.white, fontWeight: FontWeight.w100),
            ),
            footer: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 0.0),
              child: new Text(
                "monthly progress",
                style: MyStyles.robotoLight14.copyWith(
                    color: MyColors.white, fontWeight: FontWeight.w100),
              ),
            ),
            // circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

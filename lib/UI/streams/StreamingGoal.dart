import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/dimens.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/Widgets/progressbar.dart';
import 'package:myads_app/UI/authenticationScreen/signIn/LogInScreen.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';
import 'package:myads_app/UI/streams/streamProvider.dart';
import 'package:myads_app/UI/welcomeScreen/welcomeScreen.dart';
import 'package:myads_app/base/base_state.dart';
import 'package:myads_app/model/response/streams/getStreamsResponse.dart';
import 'package:myads_app/model/response/streams/updateStreamResponse.dart';
import 'package:myads_app/utils/code_snippet.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';
import 'package:provider/provider.dart';

import '../BarChart.dart';
import '../CheckMyCoupons.dart';
import '../settings/SettingScreen.dart';

class StreamingGoals extends StatefulWidget {
  @override
  _StreamingGoalsState createState() => _StreamingGoalsState();
}

class _StreamingGoalsState extends BaseState<StreamingGoals> {
  StreamsProvider _streamsProvider;

  List<StreamList> streamList = <StreamList>[];
BuildContext subcontext;
  @override
  void initState(){
    super.initState();
    _streamsProvider = Provider.of<StreamsProvider>(context,listen: false);
    _streamsProvider.listener = this;
    _streamsProvider.performGetStream();
    super.initState();

  }

  int c = 0;
  @override
  void onSuccess(any, {int reqId}) {
    ProgressBar.instance.hideProgressBar();
    super.onSuccess(any);
    switch(reqId){
      case ResponseIds.GET_STREAM:
        GetStreamResponse _response = any as GetStreamResponse;
        if(_response.streamList.isNotEmpty){
          // print("success ${_response.interests}");
          setState(() {
            _streamsProvider.setStreamList(_response.streamList);
            for(var i in _streamsProvider.getStreamList){
              streamList.add(_streamsProvider.getStreamList[c]);
              c++;
            }

          });

        } else {
          print("failure");
          CodeSnippet.instance.showMsg("Failed");
        }
        break;
      case ResponseIds.UPDATE_STREAM:
        UpdateStreamResponse _response = any as UpdateStreamResponse;
        if(_response.streams.isNotEmpty){
          print("success");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
                (route) => false,
          );
          // Navigator.of(context).pushRepla(PageRouteBuilder(
          //     pageBuilder: (_, __, ___) => new LoginScreen()));

        } else {
          print("failure");
          CodeSnippet.instance.showMsg("Failed");
        }
        break;
    }
  }
  // ignore: deprecated_member_use
  List _selecteCategorys = List();
  void _onCategorySelected(bool selected, category_name) {
    if (selected == true && _selecteCategorys.length < 3) {
      setState(() {
        _selecteCategorys.add(category_name);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.colorLight,
        automaticallyImplyLeading: false,
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
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  MyStrings.okLetsGetIntoIt,
                  style: MyStyles.robotoMedium28.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.accentsColors,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                MyStrings.selectStream,
                style: MyStyles.robotoLight20.copyWith(
                    letterSpacing: 1.0,
                    color: MyColors.accentsColors,
                    fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                MyStrings.thatYouLike,
                style: MyStyles.robotoLight20.copyWith(
                    letterSpacing: 1.0,
                    color: MyColors.accentsColors,
                    fontWeight: FontWeight.w100),
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: streamList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _selecteCategorys
                        .contains(streamList[index].value),
                    onChanged: (bool selected) {
                      _onCategorySelected(selected, streamList[index].value);
                      print(_selecteCategorys);
                    },
                    title: Text(streamList[index].value,style: MyStyles.robotoMedium24.copyWith(letterSpacing: Dimens.letterSpacing_14, color: MyColors.accentsColors, fontWeight: FontWeight.w100),),
                  );
                }),
            SizedBox(height: 20.0,),
            Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          MyStrings.basedOnSelection,
                          style: MyStyles.robotoMedium14.copyWith(
                              letterSpacing: 1.0,
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                        Text(
                          MyStrings.YouWillNeed,
                          style: MyStyles.robotoMedium14.copyWith(
                              letterSpacing: 1.0,
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                        Text(
                          MyStrings.myAdsContent,
                          style: MyStyles.robotoMedium14.copyWith(
                              letterSpacing: 1.0,
                              color: MyColors.white,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 90.0,
                  color: MyColors.lightBlueShade,
                ),

                Container(
                  child: Column(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: '0',
                                  style: MyStyles.robotoMedium60.copyWith(
                                      letterSpacing: 1.0,
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w100),
                                  children: [
                                    TextSpan(
                                      text: 'hr',
                                      style: MyStyles.robotoMedium14.copyWith(
                                          letterSpacing: 1.0,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ]),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: '12',
                                  style: MyStyles.robotoMedium60.copyWith(
                                      letterSpacing: 1.0,
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w100),
                                  children: [
                                    TextSpan(
                                      text: 'mins',
                                      style: MyStyles.robotoMedium14.copyWith(
                                          letterSpacing: 1.0,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ]),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: '00',
                                  style: MyStyles.robotoMedium60.copyWith(
                                      letterSpacing: 1.0,
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w100),
                                  children: [
                                    TextSpan(
                                      text: 'sec',
                                      style: MyStyles.robotoMedium14.copyWith(
                                          letterSpacing: 1.0,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(MyStrings.monthlyEstimate,
                          style: MyStyles.robotoLight12.copyWith(
                              letterSpacing: 1.0,
                              color: MyColors.colorLight,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  color: MyColors.accentsColors,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            SizedBox(height: 30.0,),
            InkWell(
                onTap: () {
                  print(_selecteCategorys.toString().substring(1,_selecteCategorys.toString().length-1));
                  _streamsProvider.listener = this;
                  _streamsProvider.performUpdateStream(_selecteCategorys.toString().substring(1,_selecteCategorys.toString().length-1));
                },
                child: _submitButton(MyStrings.goodToGO)),
            SizedBox(height: 30.0,),
            Center(
              child: Column(
                children: [
                  Text(
                    MyStrings.estimateOnly,
                    style: MyStyles.robotoLight14.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.lightGray,
                        fontWeight: FontWeight.w100),
                  ),
                  Text(
                    MyStrings.participating,
                    style: MyStyles.robotoLight14.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.lightGray,
                        fontWeight: FontWeight.w100),
                  ),
                  Text(
                    MyStrings.interaction,
                    style: MyStyles.robotoLight14.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.lightGray,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),

          ],
        ),
      ),
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
          subcontext=context;

          return <PopupMenuEntry<String>>[
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
                )),
            new PopupMenuDivider(height: 3.0),
            new PopupMenuItem<String>(
                value: 'value05',
                child: InkWell(
                  onTap: () async {
                    await SharedPrefManager.instance
                        .clearAll()
                        .whenComplete(
                            () => print("All set to null"));

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
        onSelected: (String value) async {
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
            await SharedPrefManager.instance
                .clearAll()
                .whenComplete(
                    () => print("All set to null"));
            Navigator.of(subcontext).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new WelcomeScreen()));
          }
        });
  }

}
Widget _submitButton(String buttonName) {
  return Container(
    width: 220.0,
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
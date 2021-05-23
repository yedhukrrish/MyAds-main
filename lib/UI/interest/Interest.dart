import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/dimens.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/Widgets/progressbar.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';
import 'package:myads_app/UI/streams/StreamingGoal.dart';
import 'package:myads_app/UI/welcomeScreen/welcomeScreen.dart';
import 'package:myads_app/base/base_state.dart';
import 'package:myads_app/model/response/interests/getInterestsResponse.dart';
import 'package:myads_app/model/response/interests/updateInterestResponse.dart';
import 'package:myads_app/utils/code_snippet.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BarChart.dart';
import '../CheckMyCoupons.dart';
import '../settings/SettingScreen.dart';
import 'interestProvider.dart';

class InterestScreen extends StatefulWidget {
  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends BaseState<InterestScreen> {
  InterestProvider _interestProvider;

  List<Interests> interestList = <Interests>[];
  BuildContext subcontext;
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
    _interestProvider = Provider.of<InterestProvider>(context, listen: false);
    _interestProvider.listener = this;
    _interestProvider.performGetInterest();
    super.initState();
  }

  int c = 0;
  @override
  Future<void> onSuccess(any, {int reqId}) async {
    ProgressBar.instance.hideProgressBar();
    super.onSuccess(any);
    switch (reqId) {
      case ResponseIds.GET_INTEREST:
        GetInterestsResponse _response = any as GetInterestsResponse;
        if (_response.interests.isNotEmpty) {
          // print("success ${_response.interests}");
          setState(() {
            _interestProvider.setInterestList(_response.interests);
            for (var i in _interestProvider.getInterestList) {
              interestList.add(_interestProvider.getInterestList[c]);
              c++;
            }
          });
        } else {
          print("failure");
          CodeSnippet.instance.showMsg("Failed");
        }
        break;
      case ResponseIds.UPDATE_INTEREST:
        UpdateInterestResponse _response = any as UpdateInterestResponse;
        if (_response.intrests.isNotEmpty) {
          String SettingsIntent =
              await sharedPrefs.getString("settingsInterestIntent");
          if ((SettingsIntent != null) && (int.parse(SettingsIntent) != 0)) {
            await SharedPrefManager.instance
                .setString("settingsInterestIntent", (0).toString());
            print("success");
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new SettingScreen()));
          } else {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new StreamingGoals()));
          }
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
        child: Consumer<InterestProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Text(
                    MyStrings.okWeAre,
                    style: MyStyles.robotoMedium28.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.w100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Text(
                    MyStrings.whatSort,
                    style: MyStyles.robotoMedium28.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.accentsColors,
                        fontWeight: FontWeight.w100),
                  ),
                ),
              ),
              Center(
                child: Text(
                  MyStrings.youLike,
                  style: MyStyles.robotoMedium28.copyWith(
                      letterSpacing: 1.0,
                      color: MyColors.accentsColors,
                      fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 1000,
                child: GridView.builder(
                    itemCount: interestList.length,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(1.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Image(
                            image: NetworkImage(interestList[index].image),
                            height: 120,
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _selecteCategorys
                                .contains(interestList[index].value),
                            onChanged: (bool selected) {
                              _onCategorySelected(
                                  selected, interestList[index].value);
                              print(_selecteCategorys);
                            },
                            title: Text(
                              interestList[index].value,
                              style: MyStyles.robotoMedium12.copyWith(
                                  letterSpacing: Dimens.letterSpacing_14,
                                  color: MyColors.accentsColors,
                                  fontWeight: FontWeight.w100),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                  onTap: () {
                    print(_selecteCategorys
                        .toString()
                        .substring(1, _selecteCategorys.toString().length - 1));
                    _interestProvider.listener = this;
                    _interestProvider.performUpdateInterest(_selecteCategorys
                        .toString()
                        .substring(1, _selecteCategorys.toString().length - 1));
                  },
                  child: _submitButton(MyStrings.thatSMe)),
              SizedBox(
                height: 10.0,
              ),
            ],
          );
        }),
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
          subcontext = context;

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
          } else if (value == 'value05') {
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
      style: MyStyles.robotoMedium14.copyWith(
          letterSpacing: 3.0,
          color: MyColors.white,
          fontWeight: FontWeight.w500),
    ),
  );
}

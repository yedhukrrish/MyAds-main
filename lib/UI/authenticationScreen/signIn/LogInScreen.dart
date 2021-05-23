import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/Constants/validate_input.dart';
import 'package:myads_app/UI/Widgets/custom_textformfield.dart';
import 'package:myads_app/UI/Widgets/progressbar.dart';
import 'package:myads_app/UI/authenticationScreen/signIn/loginProvider.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';
import 'package:myads_app/base/base_state.dart';
import 'package:myads_app/model/response/authentication/login_response.dart';
import 'package:myads_app/model/response/authentication/signup2Response.dart';
import 'package:myads_app/service/api_manager.dart';
import 'package:myads_app/service/endpoints.dart';
import 'package:myads_app/utils/code_snippet.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';
import 'package:provider/provider.dart';

import '../../BarChart.dart';
import '../../CheckMyCoupons.dart';
import '../../settings/SettingScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  LoginProvider _loginProvider;
  String emailID, Password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);
    _loginProvider.initialProvider();
    _loginProvider.listener = this;
  }

  String videoUrl;

  void _performSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _performLogin();
    } else {
      _loginProvider.setAutoValidate(true);
    }
  }

  void _performLogin() {
    _loginProvider.listener = this;
    ProgressBar.instance.showProgressbar(context);
    _loginProvider.performSignIn();
  }

  @override
  void onSuccess(any, {int reqId}) {
    ProgressBar.instance.hideProgressBar();
    super.onSuccess(any);
    switch (reqId) {
      case ResponseIds.LOGIN_SCREEN:
        SignInResponse _response = any as SignInResponse;
        if (_response.userid != null) {
          // print("success");
          SharedPrefManager.instance
              .setString(Constants.userId, _response.userid);
          SharedPrefManager.instance
              .setString(Constants.userName, _response.username);
          print(
              "userid ${SharedPrefManager.instance.getString(Constants.userId)}");
          print("success ${_response.username}");
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new DashBoardScreen()));
        } else {
          print("failure");
          CodeSnippet.instance.showMsg(_response.username);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
        child: Consumer<LoginProvider>(builder: (context, provider, _) {
          return Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        MyStrings.letSGetThis,
                        style: MyStyles.robotoMedium22.copyWith(
                            letterSpacing: 1.0,
                            color: MyColors.accentsColors,
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Center(
                    child: Text(
                      MyStrings.theRoad,
                      style: MyStyles.robotoMedium22.copyWith(
                          letterSpacing: 1.0,
                          color: MyColors.accentsColors,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  CustomTextFormField(
                    labelText: MyStrings.loginName,
                    controller: provider.usernameController,
                    validator: ValidateInput.validateEmail,
                    onSave: (value) {
                      provider.usernameController.text = value;
                    },
                  ),
                  CustomTextFormField(
                    labelText: MyStrings.password,
                    controller: provider.passwordController,
                    validator: ValidateInput.validatePassword,
                    onSave: (value) {
                      provider.passwordController.text = value;
                    },
                  ),
                  // _entryField(MyStrings.loginName),
                  // _entryField(MyStrings.password,isPassword: true),
                  SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                      onTap: () {
                        _performSubmit();
                        // print(provider.usernameController.text);
                        // print(provider.passwordController.text);
                      },
                      child: _submitButton(MyStrings.logIn)),
                  SizedBox(height: media.size.height / 4),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      MyStrings.didYouForgot,
                      style: MyStyles.robotoLight12.copyWith(
                        letterSpacing: 1.0,
                        color: MyColors.lightGray,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> getSharedPrefForUser(String uid) async {
    Map<String, String> qParams = {'u': uid};
    await ApiManager()
        .getDio(isJsonType: false)
        .post(Endpoints.userDetails, queryParameters: qParams)
        .then((response) => successResponse2(response))
        .catchError((onError) {
      onError.toString();
      print("WelcomeScreen SharedprefCall");
    });
  }

  successResponse2(Response response) async {
    SignUp2Response _response = SignUp2Response.fromJson(response.data);
    await SharedPrefManager.instance
        .setString(Constants.firstName, _response.firstName);
    await SharedPrefManager.instance
        .setString(Constants.lastName, _response.lastName);
    await SharedPrefManager.instance
        .setString(Constants.userEmail, _response.email);
    await SharedPrefManager.instance
        .setString(Constants.userMobile, _response.mobile);
    await SharedPrefManager.instance
        .setString(Constants.userPostalCode, _response.postalCode);
    await SharedPrefManager.instance
        .setString(Constants.agegroup, _response.ageGroup);
    print(_response.firstName + _response.email);
    print("Set all sharefdpref in login");
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
    width: 180.0,
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

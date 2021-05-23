import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/base/base_provider.dart';
import 'package:myads_app/model/response/authentication/demographics_response.dart';
import 'package:myads_app/model/response/authentication/signup2Response.dart';
import 'package:myads_app/service/api_manager.dart';
import 'package:myads_app/service/dio_error_util.dart';
import 'package:myads_app/service/endpoints.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';

class DemographicsProvider extends BaseProvider {
  TextEditingController firstnameController;
  TextEditingController lastnameController;
  TextEditingController emailController;
  TextEditingController mobileController;
  TextEditingController pcController;
  bool _autoValidate;
  List<AgeGroups> ageGroups;
  List<IncomeGroups> incomeGroups;
  List<CountryList> countryList;
  String type, agroup, igroup;
  initialProvider() async {
    String emailid =
        await SharedPrefManager.instance.getString(Constants.userEmail);
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController(text: emailid);
    mobileController = TextEditingController();
    pcController = TextEditingController();
    _autoValidate = false;
  }

  void setAutoValidate(bool value) {
    _autoValidate = value;
    notifyListeners();
  }

  bool get getAutoValidate => _autoValidate;

  performDemoGraphics() async {
    await ApiManager()
        .getDio(isJsonType: false)
        .post(Endpoints.getInterest)
        .then((response) => successResponse(response))
        .catchError((onError) {
      print("5");
      listener.onFailure(DioErrorUtil.handleErrors(onError));
      print("6");
    });
  }

  void successResponse(Response response) {
    DemoGraphicsResponse _response =
        DemoGraphicsResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.DEMO_SCREEN);
  }

// age list
  void setAgeList(List<AgeGroups> _ages) {
    ageGroups = _ages;
    notifyListeners();
  }

  List<AgeGroups> get getAgeList => ageGroups;

// income list
  void setIncomeList(List<IncomeGroups> _income) {
    incomeGroups = _income;
    notifyListeners();
  }

  List<IncomeGroups> get getIncomeList => incomeGroups;

  // country list
  void setCountryList(List<CountryList> _country) {
    countryList = _country;
    notifyListeners();
  }

  List<CountryList> get getCountryList => countryList;

  clearProvider() {
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    mobileController.clear();
    pcController.clear();
  }

  performSignUp2() async {
    print("1");

    Map<String, String> qParams = {
      'agroup': agroup,
      "igroup": igroup,
      "fname": firstnameController.text,
      "m": mobileController.text,
      "c": "au",
      "pc": pcController.text,
      "lname": lastnameController.text,
      'u': await SharedPrefManager.instance.getString(Constants.userId),
      "g": type
    };
    await ApiManager()
        .getDio(isJsonType: false)
        .post(Endpoints.signUp2, queryParameters: qParams)
        .then((response) => successResponse2(response))
        .catchError((onError) {
      print("5");
      listener.onFailure(DioErrorUtil.handleErrors(onError));
      print("6");
    });
  }

  void successResponse2(Response response) {
    SignUp2Response _response = SignUp2Response.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.SIGN_UP2);
  }

  void getCurrentEmail() {}

  void setTexttoEmail(String emailID) {}
}
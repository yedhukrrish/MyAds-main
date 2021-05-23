import 'package:dio/dio.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/base/base_provider.dart';
import 'package:myads_app/model/response/dashboard/getVideosResponse.dart';
import 'package:myads_app/service/api_manager.dart';
import 'package:myads_app/service/endpoints.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';

class DashboardProvider extends BaseProvider {
  performGetVideos() async {
    print("1");
    Map<String, String> qParams = {
      'u': await SharedPrefManager.instance.getString(Constants.userId),
      "v": "1"
    };
    await ApiManager()
        .getDio(isJsonType: false)
        .post(Endpoints.getVideos, queryParameters: qParams)
        .then((response) => getSuccessResponse(response))
        .catchError((onError) {
      print(onError);
    });
  }

  getSuccessResponse(Response response) {
    print("Got VideoResponse.JSON");
    VideoResponse _response = VideoResponse.fromJson(response.data);
    print("Response Data: vandhudhu");
    print("Response Data:" + _response.toJson().toString());
    listener.onSuccess(_response, reqId: ResponseIds.GET_VIDEO);
    print("Triggered listener for GetSUccessResponse");
  }
  // void setMemberList(List<Members> memberList){
  //   _members = memberList;
  //   notifyListeners();
  // }
  //
  // List<Members> get getMemberList => _members;
}

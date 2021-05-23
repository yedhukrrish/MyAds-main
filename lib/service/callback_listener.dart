import 'package:myads_app/model/response/base_response.dart';

abstract class OnCallBackListener{

  void onSuccess(dynamic any , {int reqId});

  void onFailure(BaseResponse baseResponse);
}
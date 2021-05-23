import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/constants.dart';
import 'package:myads_app/Constants/dimens.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/response_ids.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/SurveyScreen.dart';
import 'package:myads_app/UI/dashboardScreen/DashBoard.dart';
import 'package:myads_app/UI/portraitScreen/watchPortraitProvider.dart';
import 'package:myads_app/UI/webview.dart';
import 'package:myads_app/UI/Widgets/clipper.dart';
import 'package:myads_app/UI/Widgets/progressbar.dart';
import 'package:myads_app/UI/welcomeScreen/welcomeScreen.dart';
import 'package:myads_app/base/base_state.dart';
import 'package:myads_app/custom_orientation_player/controls.dart';
import 'package:myads_app/custom_orientation_player/data_manager.dart';
import 'package:myads_app/model/balance/creditBalance.dart';
import 'package:myads_app/utils/code_snippet.dart';
import 'package:myads_app/utils/shared_pref_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../BarChart.dart';
import '../CheckMyCoupons.dart';
import '../settings/SettingScreen.dart';


class WatchPortrait extends StatefulWidget {
  final String videoUrl,VideoId,watchtime,productUrl;
  WatchPortrait({this.videoUrl,this.VideoId,this.watchtime,this.productUrl});

  @override
  _WatchPortraitState createState() =>
      _WatchPortraitState();
}

class _WatchPortraitState extends BaseState<WatchPortrait> {
  FlickManager flickManager;
  DataManager dataManager;
  BuildContext subcontext;
  // List<String> urls = (mockData["items"] as List)
  //     .map<String>((item) => item["trailer_url"])
  //     .toList();
  WatchPortraitProvider _watchPortraitProvider;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
         widget.videoUrl        ),
        onVideoEnd: () {

        });
    print(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds);
    print(flickManager.flickVideoManager.videoPlayerValue.duration.inSeconds);
    _watchPortraitProvider = Provider.of<WatchPortraitProvider>(context,listen: false);
    _watchPortraitProvider.listener= this;
    dataManager = DataManager(flickManager: flickManager, urls: 'https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/the_valley_compressed.mp4?raw=true');
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  skipToVideo(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

 String balance = "0.0",username='';
  String a;
  String textPosition;
  String watch;
  @override
  void onSuccess(any, {int reqId}) {
    ProgressBar.instance.hideProgressBar();
    super.onSuccess(any);
    switch(reqId){
      case ResponseIds.CREDIT_BALANCE:
        CreditBalance _response = any as CreditBalance;
        if(_response.balance != null){
          print("success");
          print("success ${_response.balance}");
          setState(() {
            balance = _response.balance.toString();
          });
          return _showAlertPopupTransparentt();
          // print("Signup res username ${SharedPrefManager.instance.getString(Constants.userName)}");
        } else {
          print("failure");
          CodeSnippet.instance.showMsg(_response.balance.toString());
        }
        break;
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
            _DividerPopMenu()
          ],
        ),
      ),
      body:  SingleChildScrollView(
        child: VisibilityDetector(
          key: ObjectKey(flickManager),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction == 0 && this.mounted) {
              flickManager.flickControlManager?.autoPause();
            } else if (visibility.visibleFraction == 1) {
              flickManager.flickControlManager?.autoResume();
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                  preferredDeviceOrientationFullscreen: [
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,

                  ],
                  flickVideoWithControls: FlickVideoWithControls(
                    controls: CustomOrientationControls(dataManager: dataManager,videoId: widget.VideoId),
                  ),
                  flickVideoWithControlsFullscreen: FlickVideoWithControls(
                    videoFit: BoxFit.fitHeight,
                    controls: CustomOrientationControls(dataManager: dataManager,videoId: widget.VideoId),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:50.0,right: 50.0, top:30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new WebViewScreen(url: widget.productUrl,title: "Google",)));
                          print(widget.productUrl);
                        },
                        child: Image.asset(MyImages.group2)),
                    InkWell(
                        onTap: () {
                          _watchPortraitProvider.listener= this;
                          _watchPortraitProvider.performUpdateReaction("1",widget.VideoId);
                          Fluttertoast.showToast(
                              msg: "Smile Reaction added ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        },
                        child: Image.asset(MyImages.group1)),
                    InkWell(
                        onTap: () {
                          _watchPortraitProvider.listener= this;
                          _watchPortraitProvider.performUpdateReaction("0",widget.VideoId);
                          Fluttertoast.showToast(
                              msg: "Sad Reaction added ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        },
                        child: Image.asset(MyImages.group3)),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new SurveyScreen()));

                        },
                        child: Image.asset(MyImages.group4)),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child:
                          ValueListenableBuilder(
                            valueListenable: flickManager.flickVideoManager.videoPlayerController,
                            builder: (context, VideoPlayerValue value, child) {
                              //Do Something with the value.
                              return Text(value.position.toString().substring(0,7), style: MyStyles.robotoLight60.copyWith(
                                letterSpacing: 1.0,
                                color: MyColors.white,),);
                            },
                          ),),
                        Padding(
                          padding: const EdgeInsets.only(left:18.0),
                          child: Center(
                            child: Text(MyStrings.minutesThis,
                              style: MyStyles.robotoMedium12.copyWith(
                                  letterSpacing: 1.0,
                                  color: MyColors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    color: MyColors.lightBlueShade,
                  ),

                  Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ValueListenableBuilder(
                              valueListenable: flickManager.flickVideoManager.videoPlayerController,
                              builder: (context, VideoPlayerValue value, child) {
                                //Do Something with the value.
                                 a = value.position.toString().substring(0,7);
                                 Duration position = flickManager.flickVideoManager.videoPlayerValue.position;

                                 String positionInSeconds = position != null
                                     ? (position - Duration(minutes: position.inMinutes))
                                     .inSeconds
                                     .toString()
                                     .padLeft(2, '0')
                                     : null;

                                 
                                 textPosition = position != null ? '${position.inMinutes}.$positionInSeconds' : '0.00';
                                 var format = DateFormat("HH:mm:ss");
                                 var one = format.parse(value.position.toString().substring(0,7));
                                 var two = format.parse(widget.watchtime);
                               
                                return Text("${two.difference(one)}".substring(0,7), style: MyStyles.robotoLight60.copyWith(
                                  letterSpacing: 1.0,
                                  color: MyColors.white,),);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0),
                            child: Center(
                              child: Text(MyStrings.yearned,
                                style: MyStyles.robotoMedium12.copyWith(
                                    letterSpacing: 1.0,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w100),
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100.0,
                      color: MyColors.accentsColors,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              InkWell(
                onTap: () async {
                  // print(double.parse(textPosition));
                  _watchPortraitProvider.listener= this;
                  _watchPortraitProvider.performAddBalance(textPosition,widget.VideoId,textPosition);
                  username  = await SharedPrefManager.instance.getString(Constants.userName);
                  print(username);

                },
                child: _submitButton(MyStrings.addtocredit),),
              SizedBox(
                height: 30.0,
              ),
              InkWell(
                onTap: () async {
                  // print(double.parse(textPosition));
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new DashBoardScreen()));

                },
                child: _submitButton(MyStrings.enoughForNow),),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
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

  void _showAlertPopupTransparentt() {
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.only(left:0.0,),
      content: Stack(
        children: [
          Stack(
            children: [
              RotatedBox(
                quarterTurns: 4,
                child: ClipPath(
                  clipper: DiagonalPathClipperOne(),
                  child: Container(
                    height: 25,
                    color: MyColors.lightBlueShade,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 4,
                child: ClipPath(
                  clipper: DiagonalPathClipperTwo(),
                  child: Container(
                    height: 25,
                    color:  MyColors.accentsColors,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: ClipPath(
                          clipper: DiagonalPathClipperOne(),
                          child: Container(
                            height: 20,
                            width: 600.0,
                            color: MyColors.lightBlueShade,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:80.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 150.0,
                                width: 150.0,
                                child: Image.asset('assets/images/FoziSmall.png')),
                            SizedBox(
                                width: 170.0,
                                child: Image.asset('assets/images/MaskGroup.png'))
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: ClipPath(
                                    clipper: DiagonalPathClipperOne(),
                                    child: Container(
                                      height: 40,
                                      width: 500.0,
                                      color: MyColors.lightBlueShade,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Hi $username',
                                      textAlign: TextAlign.left,
                                      style: MyStyles.robotoLight30.copyWith(letterSpacing: Dimens.letterSpacing_14, color: MyColors.textColor1b1c20, fontWeight: FontWeight.w100),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Text(MyStrings.congratulations,
                                      textAlign: TextAlign.left,
                                      style: MyStyles.robotoBold30.copyWith(letterSpacing: Dimens.letterSpacing_14, color: MyColors.textColor1b1c20, fontWeight: FontWeight.w100),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80.0,),
                                      child: Text(MyStrings.thanksForWatching,
                                        style: MyStyles.robotoMedium18.copyWith(letterSpacing: 1.0, height: 1.5, color: MyColors.textColor1b1c20, fontWeight: FontWeight.w100),
                                        textAlign: TextAlign.left,),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:50.0, bottom: 50.0),
                                child: Center(
                                  child: InkWell(
                                      onTap: () {
                                        // Navigator.of(context).push(PageRouteBuilder(
                                        //     pageBuilder: (_, __, ___) => new DemographicsScreen()));
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                                      },
                                      child: _submitButton(MyStrings.getGiftCard)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:25.0, right: 25.0),
                                child: Text(MyStrings.youWillBeNotified,
                                  style: MyStyles.robotoMedium16.copyWith(letterSpacing: 1.0, color: MyColors.textColor1b1c20, fontWeight: FontWeight.w100),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RotatedBox(
                                quarterTurns:3,
                                child: ClipPath(
                                  clipper: DiagonalPathClipperTwo(),
                                  child: Container(
                                    height: 40,
                                    width: 500.0,
                                    color: MyColors.accentsColors,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: ClipPath(
                            clipper: DiagonalPathClipperTwo(),
                            child: Container(
                              height: 20,
                              width: 400.0,
                              color: MyColors.accentsColors,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      insetPadding: EdgeInsets.only(left:25.0,right: 25.0,top: 10.0,bottom: 52
      ),
      // backgroundColor: MyColors.accentsColors.withOpacity(0.8),
    );
    showDialog(context: context, builder: (context) => dialog,);
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

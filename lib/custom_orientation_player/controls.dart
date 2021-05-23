import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/images.dart';
import 'package:myads_app/Constants/strings.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/UI/SurveyScreen.dart';
import 'package:myads_app/UI/webview.dart';
import 'package:myads_app/landscape_player/play_toggle.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'data_manager.dart';

class CustomOrientationControls extends StatelessWidget {
  const CustomOrientationControls(
      {Key key, this.iconSize = 20, this.fontSize = 12, this.dataManager, this.videoId})
      : super(key: key);
  final double iconSize;
  final double fontSize;
  final DataManager dataManager;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);

    return Stack(
      children: <Widget>[
        FlickShowControlsAction(
          child: FlickSeekVideoAction(
            child: Center(
              child: FlickVideoBuffer(
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: LandscapePlayToggle(VideoId: this.videoId,),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickCurrentPosition(
                        fontSize: fontSize,
                      ),
                      FlickTotalDuration(
                        fontSize: fontSize,
                      ),
                      Expanded(
                        child: Container(),
                      ),

                      SizedBox(
                        width: 10,
                      ),
                      FlickSoundToggle(
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickFullScreenToggle()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 1,
            top: MediaQuery.of(context).size.height/3.4,
            child:Column(
              children: [
                Container(
                  height: 100.0,
                  width: 200.0,
                  color: MyColors.primaryColor.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      children: [
                        // VideoProgressIndicator(
                        //   flickVideoManager.videoPlayerController,//controller
                        //   allowScrubbing: true,
                        //   colors: VideoProgressColors(
                        //     playedColor: MyColors.accentsColors,
                        //     bufferedColor: Colors.red,
                        //     backgroundColor: MyColors.black,
                        //   ),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: flickVideoManager.videoPlayerController,
                              builder: (context, VideoPlayerValue value, child) {
                                //Do Something with the value.
                                return Text(value.position.toString().substring(0,7), style: MyStyles.robotoLight60.copyWith(
                                  letterSpacing: 1.0,
                                  color: MyColors.white,),);
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:18.0),
                          child: Text(MyStrings.Watched,
                            style: MyStyles.robotoLight12.copyWith(
                                letterSpacing: 1.0,
                                color: MyColors.colorLight,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100.0,
                  width: 200.0,
                  color: MyColors.accentsColors.withOpacity(0.5),
                  child: Center(
                      child:Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: flickVideoManager.videoPlayerController,
                            builder: (context, VideoPlayerValue value, child) {
                              //Do Something with the value.
                              return Text("\$"+value.position.toString().substring(2,7), style: MyStyles.robotoLight60.copyWith(
                                letterSpacing: 1.0,
                                color: MyColors.white,),);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:18.0),
                            child: Text(MyStrings.yearned,
                              style: MyStyles.robotoLight12.copyWith(
                                  letterSpacing: 1.0,
                                  color: MyColors.colorLight,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            )
        ),
        Padding(
          padding: const EdgeInsets.only(left:50.0,right: 50.0, top:310.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(url: "https://www.google.com/",title: "Google",)));
                  },
                  child: Image.asset(MyImages.group2)),
              SizedBox(width: 15,),
              Image.asset(MyImages.group1),
              SizedBox(width: 15,),
              Image.asset(MyImages.group3),
              SizedBox(width: 15,),
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyScreen()));
                  },
                  child: Image.asset(MyImages.group4)),
            ],
          ),
        ),
      ],
    );
  }
}

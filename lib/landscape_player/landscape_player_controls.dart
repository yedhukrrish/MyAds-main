import 'dart:ui';
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

class LandscapePlayerControls extends StatelessWidget {
  const  LandscapePlayerControls(
      {Key key, this.iconSize = 20, this.fontSize = 12, this.flickManager})
      : super(key: key);
  final double iconSize;
  final double fontSize;
  final FlickManager flickManager;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlickShowControlsAction(
          child: FlickSeekVideoAction(
            child: Center(
              child: FlickVideoBuffer(
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: LandscapePlayToggle(),
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
                      SizedBox(
                        width: 10,
                      ),

                      // Expanded(
                      //   child: Container(
                      //     child: FlickVideoProgressBar(
                      //       flickProgressBarSettings: FlickProgressBarSettings(
                      //         height: 10,
                      //         handleRadius: 10,
                      //         padding: EdgeInsets.symmetric(
                      //           horizontal: 8.0,
                      //           vertical: 8,
                      //         ),
                      //         backgroundColor: Colors.white24,
                      //         bufferedColor: Colors.white38,
                      //         getPlayedPaint: (
                      //             {double handleRadius,
                      //             double height,
                      //             double playedPart,
                      //             double,
                      //             width}) {
                      //           return Paint()
                      //             ..shader = LinearGradient(colors: [
                      //               Color.fromRGBO(108, 165, 242, 1),
                      //               Color.fromRGBO(97, 104, 236, 1)
                      //             ], stops: [
                      //               0.0,
                      //               0.5
                      //             ]).createShader(
                      //               Rect.fromPoints(
                      //                 Offset(0, 0),
                      //                 Offset(width, 0),
                      //               ),
                      //             );
                      //         },
                      //         getHandlePaint: (
                      //             {double handleRadius,
                      //             double height,
                      //             double playedPart,
                      //             double,
                      //             width}) {
                      //           return Paint()
                      //             ..shader = RadialGradient(
                      //               colors: [
                      //                 Color.fromRGBO(97, 104, 236, 1),
                      //                 Color.fromRGBO(97, 104, 236, 1),
                      //                 Colors.white,
                      //               ],
                      //               stops: [0.0, 0.4, 0.5],
                      //               radius: 0.4,
                      //             ).createShader(
                      //               Rect.fromCircle(
                      //                 center: Offset(playedPart, height / 2),
                      //                 radius: handleRadius,
                      //               ),
                      //             );
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      FlickTotalDuration(
                        fontSize: fontSize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlickSoundToggle(
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: GestureDetector(
            onTap: () {
              SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
        ),
        Positioned(
          right: 1,
          top: MediaQuery.of(context).size.height/3.6,
          child:Column(
            children: [
              Container(
                height: 100.0,
                width: 200.0,
                color: MyColors.primaryColor.withOpacity(0.5),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: '0',
                                style: MyStyles.robotoLight60.copyWith(
                                    letterSpacing: 1.0,
                                    color: MyColors.white,),
                                children: [
                                  TextSpan(
                                    text: 'hr',
                                    style: MyStyles.robotoLight14.copyWith(
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
                                style: MyStyles.robotoLight60.copyWith(
                                    letterSpacing: 1.0,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w100),
                                children: [
                                  TextSpan(
                                    text: 'mins',
                                    style: MyStyles.robotoLight14.copyWith(
                                        letterSpacing: 1.0,
                                        color: MyColors.white,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ]),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: '0',
                                style: MyStyles.robotoLight60.copyWith(
                                  letterSpacing: 1.0,
                                  color: MyColors.white,),
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
                                style: MyStyles.robotoLight60.copyWith(
                                    letterSpacing: 1.0,
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w100),
                                children: [
                                  TextSpan(
                                    text: 'mins',
                                    style: MyStyles.robotoLight14.copyWith(
                                        letterSpacing: 1.0,
                                        color: MyColors.white,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:18.0),
                        child: Text(MyStrings.goto,
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

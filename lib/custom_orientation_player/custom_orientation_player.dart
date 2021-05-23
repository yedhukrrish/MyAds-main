
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myads_app/Constants/colors.dart';
import 'package:myads_app/Constants/styles.dart';
import 'package:myads_app/utils/mock_data.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'controls.dart';
import 'data_manager.dart';

class CustomOrientationPlayer extends StatefulWidget {
  CustomOrientationPlayer({Key key}) : super(key: key);

  @override
  _CustomOrientationPlayerState createState() =>
      _CustomOrientationPlayerState();
}

class _CustomOrientationPlayerState extends State<CustomOrientationPlayer> {
   FlickManager flickManager;
   DataManager dataManager;
  // List<String> urls = (mockData["items"] as List)
  //     .map<String>((item) => item["trailer_url"])
  //     .toList();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          'https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/the_valley_compressed.mp4?raw=true',
        ),
        onVideoEnd: () {

        });
    print(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds);
    print(flickManager.flickVideoManager.videoPlayerValue.duration.inSeconds);

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

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
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
                controls: CustomOrientationControls(dataManager: dataManager),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.fitHeight,
                controls: CustomOrientationControls(dataManager: dataManager),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: flickManager.flickVideoManager.videoPlayerController,
            builder: (context, VideoPlayerValue value, child) {
              //Do Something with the value.
              return Text(value.position.toString().substring(0,7), style: MyStyles.robotoLight60.copyWith(
                letterSpacing: 1.0,
                color: MyColors.black,),);
            },
          ),
          Text("gafsdjhfasjh"),
          Text("gafsdjhfasjh")
        ],
      ),
    );
  }
}

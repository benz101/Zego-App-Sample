// Flutter imports:

import 'package:flutter/material.dart';
import 'package:zego_app_sample/helper/common.dart';
import 'package:zego_app_sample/helper/constants.dart';
// Project imports:
// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class WatchLiveStreamingPage extends StatefulWidget {
  final String liveID;
  final String localUserID;

  const WatchLiveStreamingPage({
    super.key,
    required this.liveID,
    required this.localUserID,
  });

  @override
  State<StatefulWidget> createState() => WatchLiveStreamingPageState();
}

class WatchLiveStreamingPageState extends State<WatchLiveStreamingPage> {
  @override
  void dispose() {
    ZegoUIKit().leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: ZegoUIKitPrebuiltLiveStreaming(
                    appID: appID /*input your AppID*/,
                    appSign: appSign /*input your AppSign*/,
                    userID: localUserID,
                    userName: 'user_$localUserID',
                    liveID: widget.liveID,
                    config: ZegoUIKitPrebuiltLiveStreamingConfig.audience()
                      ..avatarBuilder = customAvatarBuilder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

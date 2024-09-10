// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_app_sample/helper/constants.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// Project imports:
import '../helper/common.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LivePage({
    super.key,
    required this.liveID,
    this.isHost = false,
  });

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 0 /*input your AppID*/,
        appSign: '' /*input your AppSign*/,
        userID: '',
        userName: 'user_$localUserID',
        liveID: widget.liveID,
        config: (widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }
}

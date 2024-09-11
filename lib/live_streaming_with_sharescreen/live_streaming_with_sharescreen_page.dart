import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_app_sample/helper/common.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamingWithShareScreenPage extends StatefulWidget {
  final String liveID;
  final bool useVideoViewAspectFill;

  const LiveStreamingWithShareScreenPage({
    super.key,
    required this.liveID,
    this.useVideoViewAspectFill = true,
  });

  @override
  State<LiveStreamingWithShareScreenPage> createState() =>
      _LiveStreamingWithShareScreenPageState();
}

class _LiveStreamingWithShareScreenPageState
    extends State<LiveStreamingWithShareScreenPage> {
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your Live ID: ${widget.liveID}'),
                      const SizedBox(width: 5),
                      IconButton(
                          onPressed: () async {
                            Fluttertoast.showToast(
                                msg: 'Live ID has been copied');
                            await Clipboard.setData(
                                ClipboardData(text: widget.liveID));
                          },
                          icon: const Icon(Icons.copy)),
                      IconButton(
                          onPressed: () => shareTo(
                              param: 'This live id of host: ${widget.liveID}'),
                          icon: const Icon(Icons.share)),
                    ],
                  ),
                ),
                Expanded(
                  child: ZegoUIKitPrebuiltLiveStreaming(
                    appID: appID, // Your App ID
                    appSign: appSign, // Your App Sign
                    userID: localUserID,
                    userName: 'user_$localUserID',
                    liveID: widget.liveID,
                    config: (ZegoUIKitPrebuiltLiveStreamingConfig.host()
                      // Customize the layout to gallery mode
                      ..layout = ZegoLayout.gallery(
                        showScreenSharingFullscreenModeToggleButtonRules:
                            ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                        showNewScreenSharingViewInFullscreenMode: false,
                      )
                      // Add a screen-sharing toggle button in the bottom menu
                      ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                        hostButtons: [
                          ZegoLiveStreamingMenuBarButtonName
                              .toggleScreenSharingButton, // Screen share toggle button
                          ZegoLiveStreamingMenuBarButtonName
                              .toggleMicrophoneButton, // Mic toggle button
                          ZegoLiveStreamingMenuBarButtonName
                              .toggleCameraButton, // Camera toggle button
                        ],
                      )),
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

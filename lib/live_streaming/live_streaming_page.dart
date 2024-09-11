import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_app_sample/helper/common.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamingPage extends StatefulWidget {
  final String liveID;

  const LiveStreamingPage({
    super.key,
    required this.liveID,
  });

  @override
  State<StatefulWidget> createState() => LiveStreamingPageState();
}

class LiveStreamingPageState extends State<LiveStreamingPage> {
  @override
  void dispose() {
    ZegoUIKit().leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Your Live ID: ${widget.liveID}'),
                    const SizedBox(width: 5),
                    IconButton(
                        onPressed: () async {
                          Fluttertoast.showToast(msg: 'Live ID has been copied');
                          await Clipboard.setData(
                              ClipboardData(text: widget.liveID));
                          // copied successfully
                        },
                        icon: const Icon(Icons.copy)),
                    IconButton(onPressed: () =>  shareTo(param: 'This live id of host: ${widget.liveID}'), icon: const Icon(Icons.share)),
                  ]),
                ),
                Expanded(
                  child: ZegoUIKitPrebuiltLiveStreaming(
                    appID: appID /*input your AppID*/,
                    appSign: appSign /*input your AppSign*/,
                    userID: localUserID,
                    userName: 'user_$localUserID',
                    liveID: widget.liveID,
                    config: ZegoUIKitPrebuiltLiveStreamingConfig.host()
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

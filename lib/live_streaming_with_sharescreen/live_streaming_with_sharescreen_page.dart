// integrate code :
import 'package:flutter/material.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamingWithShareScreenPage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  final bool useVideoViewAspectFill;

  const LiveStreamingWithShareScreenPage({
    super.key,
    required this.liveID,
    this.isHost = false,
    this.useVideoViewAspectFill = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 0 /*input your AppID*/,
        appSign: '' /*input your AppSign*/,
        userID: '',
        userName: 'user_$localUserID',
        liveID: liveID,
        // Modify your custom configurations here.
        config: isHost
            ? (ZegoUIKitPrebuiltLiveStreamingConfig.host()
                  ..layout = ZegoLayout.gallery(
                      showScreenSharingFullscreenModeToggleButtonRules:
                          ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                      showNewScreenSharingViewInFullscreenMode:
                          false) //  Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
                  ..bottomMenuBar =
                      ZegoLiveStreamingBottomMenuBarConfig(hostButtons: [
                    ZegoLiveStreamingMenuBarButtonName
                        .toggleScreenSharingButton,
                    ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
                    ZegoLiveStreamingMenuBarButtonName.toggleCameraButton
                  ]) // Add a screen sharing toggle button.
                )
            : (ZegoUIKitPrebuiltLiveStreamingConfig.audience()
              ..layout = ZegoLayout.gallery(
                  showScreenSharingFullscreenModeToggleButtonRules:
                      ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                  showNewScreenSharingViewInFullscreenMode:
                      false) // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
              ..bottomMenuBar =
                  ZegoLiveStreamingBottomMenuBarConfig(hostButtons: [
                ZegoLiveStreamingMenuBarButtonName.toggleScreenSharingButton,
                ZegoLiveStreamingMenuBarButtonName.coHostControlButton
              ]) // Add a screen sharing toggle button.
            ),
      ),
    );
  }

  Image prebuiltImage(String name) {
    return Image.asset(name, package: 'zego_uikit_prebuilt_live_streaming');
  }

  Widget hostAudioVideoViewForegroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    if (user == null || user.id == localUserID) {
      return Container();
    }

    const toolbarCameraNormal = 'assets/icons/toolbar_camera_normal.png';
    const toolbarCameraOff = 'assets/icons/toolbar_camera_off.png';
    const toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
    const toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
    return Positioned(
      top: 15,
      right: 0,
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getCameraStateNotifier(user.id),
            builder: (context, isCameraEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit().turnCameraOn(!isCameraEnabled, userID: user.id);
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isCameraEnabled ? toolbarCameraNormal : toolbarCameraOff,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: size.width * 0.1),
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getMicrophoneStateNotifier(user.id),
            builder: (context, isMicrophoneEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit()
                      .turnMicrophoneOn(!isMicrophoneEnabled, userID: user.id);
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isMicrophoneEnabled ? toolbarMicNormal : toolbarMicOff,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<bool> onTurnOnAudienceDeviceConfirmation(
    BuildContext context,
    bool isCameraOrMicrophone,
  ) async {
    const textStyle = TextStyle(fontSize: 10, color: Colors.white70);
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900]!.withOpacity(0.9),
          title: Text(
              "You have a request to turn on your ${isCameraOrMicrophone ? "camera" : "microphone"}",
              style: textStyle),
          content: Text(
              "Do you agree to turn on the ${isCameraOrMicrophone ? "camera" : "microphone"}?",
              style: textStyle),
          actions: [
            ElevatedButton(
              child: const Text('Cancel', style: textStyle),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('OK', style: textStyle),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

Widget switchDropList<T>(
  ValueNotifier<T> notifier,
  List<T> itemValues,
  Widget Function(T value) widgetBuilder,
) {
  return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: itemValues.map((T itemValue) {
            return DropdownMenuItem(
              value: itemValue,
              child: widgetBuilder(itemValue),
            );
          }).toList(),
          onChanged: (T? newValue) {
            if (newValue != null) {
              notifier.value = newValue;
            }
          },
        );
      });
}

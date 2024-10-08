import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';


import 'minigame/service/mini_game_api.dart';
import 'minigame/ui/show_game_list_view.dart';
import 'minigame/your_game_server.dart';

part 'live_audio_room_game.dart';

class LiveAudioRoomPage extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;

  const LiveAudioRoomPage({
    super.key,
    required this.roomID,
    required this.userID,
    required this.userName,
    this.isHost = false,
  });

  @override
  State<StatefulWidget> createState() => LiveAudioRoomPageState();
}

class LiveAudioRoomPageState extends State<LiveAudioRoomPage> {
  late final InRoomGameController _gameCtrl = InRoomGameController(
    userID: widget.userID,
    userName: widget.userName,
    roomID: widget.roomID,
    isHost: widget.isHost,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _gameCtrl.init(); // you need uninit _gameCtrl in the onWillPop block
    });
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.host();
    final audienceConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) await _gameCtrl.uninit();
      },
      child: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltLiveAudioRoom(
              appID: appID /*input your AppID*/,
              appSign: appSign /*input your AppSign*/,
              userID: widget.userID,
              userName: widget.userName,
              roomID: widget.roomID,
              config: (widget.isHost ? hostConfig : audienceConfig)
                ..userAvatarUrl =
                    'https://robohash.org/$localUserID.png?set=set4'
                ..seat.closeWhenJoining = false
                ..bottomMenuBar.hostExtendButtons = [_gameCtrl.gameButton()]
                ..bottomMenuBar.hostButtons = [
                  ZegoLiveAudioRoomMenuBarButtonName.toggleMicrophoneButton,
                  ZegoLiveAudioRoomMenuBarButtonName.showMemberListButton,
                ]
                ..emptyAreaBuilder = ((_) => _gameCtrl.gameView())
                ..background = background(),
            ),
          ],
        ),
      ),
    );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/background.png'),
            ),
          ),
        ),
        const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}

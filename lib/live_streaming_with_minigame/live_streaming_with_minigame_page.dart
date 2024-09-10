import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_app_sample/helper/common.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'minigame/service/mini_game_api.dart';
import 'minigame/ui/show_game_list_view.dart';
import 'minigame/your_game_server.dart';

class LiveStreamingWithMiniGamePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  // final String userID;
  // final String userName;

  const LiveStreamingWithMiniGamePage({
    super.key,
    required this.liveID,
    // required this.userID,
    // required this.userName,
    this.isHost = false,
  });

  @override
  State<StatefulWidget> createState() => LiveStreamingWithMiniGamePageState();
}

class LiveStreamingWithMiniGamePageState extends State<LiveStreamingWithMiniGamePage> {
  final liveStreamingStateNotifier = ValueNotifier(ZegoLiveStreamingState.idle);
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    return WillPopScope(
      onWillPop: () async {
        await ZegoMiniGame().unloadGame();
        await ZegoMiniGame().uninitGameSDK();
        await ZegoMiniGame().uninitWebViewController();
        return true;
      },
      child: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
                appID: appID /*input your AppID*/,
                appSign: appSign /*input your AppSign*/,
                userID: '',
                userName: '',
                liveID: widget.liveID,
                events: ZegoUIKitPrebuiltLiveStreamingEvents(
                  onStateUpdated: (state) =>
                      liveStreamingStateNotifier.value = state,
                ),
                config: (widget.isHost ? hostConfig : audienceConfig)
                  ..avatarBuilder = customAvatarBuilder
                  ..audioVideoView.useVideoViewAspectFill = false),
            Offstage(
              offstage: !playing,
              child: InAppWebView(
                initialFile: 'assets/minigame/index.html',
                onWebViewCreated: (InAppWebViewController controller) async {
                  ZegoMiniGame().initWebViewController(controller);
                },
                onLoadStop: (controller, url) async {
                  final token = await YourGameServer().getToken(
                    appID: appID,
                    userID: '',
                    serverSecret: '',
                  );

                  await ZegoMiniGame().initGameSDK(
                    appID: appID,
                    token: token,
                    userID: '',
                    userName: '',
                    avatarUrl: Uri.encodeComponent('https://robohash.org/${''}.png?set=set4'),
                    language: GameLanguage.english,
                  );
                },
                onConsoleMessage: (controller, ConsoleMessage msg) async {
                  debugPrint('[InAppWebView][${msg.messageLevel}]${msg.message}');
                },
              ),
            ),
            gameButton(),
          ],
        ),
      ),
    );
  }

  Widget gameButton() {
    return ValueListenableBuilder(
      valueListenable: liveStreamingStateNotifier,
      builder: (context, liveStreamingState, _) {
        if (liveStreamingState != ZegoLiveStreamingState.living) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: playing ? 10 : null,
          top: playing ? 10 : null,
          bottom: playing ? null : 80,
          right: playing ? null : 10,
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (!playing) {
                showGameListView(context).then((ZegoGameInfo? gameInfo) async {
                  if (gameInfo != null) {
                    final gameID = gameInfo.miniGameId!;
                    final gameMode = gameInfo.gameMode!;
                    debugPrint('[APP]load game: $gameID');
                    try {
                      final loadGameResult = await ZegoMiniGame().loadGame(
                        gameID: gameID,
                        gameMode: ZegoGameMode.values.where((element) => element.value == gameMode[0]).first,
                        loadGameConfig: ZegoLoadGameConfig(minGameCoin: 0, roomID: widget.liveID, useRobot: true),
                      );
                      debugPrint('[APP]loadGame: $loadGameResult');
                      setState(() => playing = true);
                    } catch (e) {
                      Fluttertoast.showToast(msg:'getUserCurrency:$e');
                    }
                    try {
                      final exchangeUserCurrencyResult = await YourGameServer().exchangeUserCurrency(
                        appID: appID,
                        gameID: gameID,
                        userID: '',
                        exchangeValue: 10000,
                        outOrderId: DateTime.now().millisecondsSinceEpoch.toString(),
                      );
                      debugPrint('[APP]exchangeUserCurrencyResult: $exchangeUserCurrencyResult');
                    } catch (e) {
                      Fluttertoast.showToast(msg:'exchangeUserCurrency:$e');
                    }
                    try {
                      final getUserCurrencyResult = await YourGameServer().getUserCurrency(
                        appID: appID,
                        userID: '',
                        gameID: gameID,
                      );
                      debugPrint('[APP]getUserCurrencyResult: $getUserCurrencyResult');
                    } catch (e) {
                      Fluttertoast.showToast(msg:'getUserCurrency:$e');
                    }
                  }
                });
              } else {
                await ZegoMiniGame().unloadGame();
                setState(() => playing = false);
              }
            },
            label: playing ? const Text('Quit Game') : const Text('Game List'),
            icon: playing ? const Icon(Icons.arrow_back) : const Icon(Icons.games),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zego_app_sample/live_streaming/live_page.dart';
import 'package:zego_app_sample/live_streaming_with_cohosting/live_page_with_cohosting.dart';
import 'package:zego_app_sample/live_streaming_with_minigame/live_streaming_with_minigame_page.dart';
import 'package:zego_app_sample/live_streaming_with_sharescreen/live_streaming_with_sharescreen_page.dart';

class MenuPage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String? localUserID;
  const MenuPage({super.key, required this.liveID, required this.isHost, this.localUserID});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome To The Menu')),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LivePage(
                                liveID: widget.liveID, isHost: widget.isHost))),
                    child: const Text('Go To Live Streaming')),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LivePageWithCohosting(
                                liveID: widget.liveID, isHost: widget.isHost, localUserID: widget.localUserID??''))),
                    child: const Text('Go To Live Streaming With Cohosting')),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveStreamingWithMiniGamePage(
                                liveID: widget.liveID, isHost: widget.isHost))),
                    child: const Text('Go To Live Streaming With Mini Game')),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveStreamingWithShareScreenPage(
                                liveID: widget.liveID, isHost: widget.isHost))),
                    child: const Text('Go To Live Streaming With Sharescreen')),
                const SizedBox(height: 15)
              ])),
    );
  }
}

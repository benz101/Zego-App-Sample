import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_app_sample/helper/constants.dart';
import 'package:zego_app_sample/live_streaming/live_streaming_page.dart';
import 'package:zego_app_sample/live_streaming_for_audience/watch_live_streaming_page.dart';
import 'package:zego_app_sample/live_streaming_with_minigame/live_streaming_with_minigame_page.dart';
import 'package:zego_app_sample/live_streaming_with_sharescreen/live_streaming_with_sharescreen_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage(
      {super.key
      });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController liveIDCtrl = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Welcome To The Menu')),
        body: _buildListMenu());
  }

  Widget _buildListMenu() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            for (int i = 0; i <= 3; i++) // Loop based on number of menus
              GestureDetector(
                onTap: getMenu(i).onPress,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: getMenu(i).icon,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: Text(
                          getMenu(i)
                              .name, // Use loop counter for dynamic menu numbering
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
    );
  }

  ItemOfMenu getMenu(int index) {
    switch (index) {
      case 0:
        return ItemOfMenu(
            name: 'Start Live Streaming',
            icon: const Icon(Icons.video_call, size: 60),
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LiveStreamingPage(
                        liveID: Random().nextInt(10000).toString()))));
      case 1:
        return ItemOfMenu(
            name: 'Watch Live Streaming',
            icon: const Icon(Icons.person_2, size: 60),
            onPress: () => showAlertDialog(context)
                        );
      case 2:
        return ItemOfMenu(
            name: 'Live Streaming With Mini Game',
            icon: const Icon(Icons.gamepad,  size: 60),
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LiveStreamingWithMiniGamePage(
                        liveID: Random().nextInt(10000).toString()))));
      case 3:
        return ItemOfMenu(
            name: 'Live Streaming With Share Screen',
            icon: const Icon(Icons.screen_share, size: 60),
            onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LiveStreamingWithShareScreenPage(
                        liveID: Random().nextInt(10000).toString()))));
      default:
        return ItemOfMenu(
            name: 'Undefined Menu', icon: Container(), onPress: () {});
    }
  }

  void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Please Enter Live ID Of Host', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        content: TextField(
          controller: liveIDCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter Live ID'),

        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              if (liveIDCtrl.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Live ID must be filled');
                return;
              }
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WatchLiveStreamingPage(
                        liveID: liveIDCtrl.text,
                        localUserID: 'user_$localUserID')));
            },
          ),
        ],
      );
    },
  );
}
}

class ItemOfMenu {
  final String name;
  final Widget icon;
  final Function() onPress;
  ItemOfMenu({required this.name, required this.icon, required this.onPress});
}

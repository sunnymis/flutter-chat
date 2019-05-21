import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:friendlychat/chat-screen.dart';
import 'package:friendlychat/themes.dart';

void main() => runApp(FriendlyChatApp());

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Friendly Chat App',
      home: new ChatScreen(),
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? kIOSTheme
        : kDefaultTheme,
    );
  }
}



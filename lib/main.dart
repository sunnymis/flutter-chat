import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(FriendlyChatApp());

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

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

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = true;


  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
  
  void _handleSubmitted(String text) {
    _textEditingController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    // _messages.add(message)
    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return Container(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new Row(children: <Widget>[
          Flexible(
            child: new TextField(
              controller: _textEditingController,
              onSubmitted: _handleSubmitted,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            )
          ),
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: IconTheme(
              data: new IconThemeData(color: Theme.of(context).accentColor),
              child: Theme.of(context).platform == TargetPlatform.iOS
                ? new CupertinoButton(
                  child: Text("Send"),
                  onPressed: _isComposing
                    ? () =>_handleSubmitted(_textEditingController.text)
                    : null,
                )
                : new IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing
                    ? () =>_handleSubmitted(_textEditingController.text)
                    : null,
                  color: Colors.blue,
                )
            )
          )
        ])
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friendlychatz'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS
          ? 0.0
          : 4.0,
      ),
      body: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                Divider(height: 1.0),
                Container(
                  decoration: new BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]))
            ),
        ),
      );
  }
}

// 
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final String _name = "Sunny";
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController, curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0])
              )
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text)
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hackthon/AnswerScreen.dart';
import 'package:hackthon/main.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

const String _name = "Husayn";

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State with TickerProviderStateMixin {
  final _messages = <ChatMessage>[];
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/logo.png"),
          ),
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          Divider(height: 1.0),
          Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer())
        ]));
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: <Widget>[
              Flexible(
                  child: TextField(
                      controller: _textEditingController,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration.collapsed(
                          hintText: "Send a message"))),
              Container(
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () =>
                          _handleSubmitted(_textEditingController.text)))
            ])));
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    addMessage(true, text);
    _getBotResponse(text);
  }

  @override
  void dispose() {
    for (var message in _messages) message.animationController.dispose();
    super.dispose();
  }

  void _getBotResponse(String request) async {
    ask("我想學Flutter");
    String response = "I don't know";
    List<String> options = ["iOS", "Android", "Web"];
    addMessage(false, response, options: options, isEnd: Random().nextBool());
  }

  void addMessage(bool isUser, String text,
      {List<String> options, bool isEnd = false}) {
    var message = ChatMessage(
        isUser: isUser,
        text: text,
        options: options,
        isEnd: isEnd,
        animationController: AnimationController(
          duration: Duration(microseconds: 500),
          vsync: this,
        ));
    setState(() => _messages.insert(0, message));
    message.animationController.forward();
  }

  void ask(String question) async {
    print("ASKING...");
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(
        authGoogle: authGoogle, language: Language.chineseTraditional);
    AIResponse response = await dialogflow.detectIntent(question);
    print(response.getListMessage());
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.isUser,
      this.text,
      this.options,
      this.isEnd,
      this.animationController});

  final bool isUser;
  final bool isEnd;
  final String text;
  final List<String> options;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: <Widget>[
          _buildMessage(isUser),
          _buildOptions(options),
          _buildAskQuestion(context),
        ]),
      ),
    );
  }

  Widget _buildMessage(bool isUser) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 16 : 0),
            topRight: Radius.circular(isUser ? 0 : 16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildOptions(List<String> options) {
    return options == null
        ? Container()
        : Row(children: options.map(_buildOption).toList());
  }

  Widget _buildOption(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffd2eefe),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(tag),
    );
  }

  Widget _buildAskQuestion(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => AnswerScreen(
        question: Question(
          "Title", "Content", ["Android", "iOS", "Web"]
        ),
        answer: "This is my answer",
      ))),
      child: isEnd
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff2ac9fd),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Yes, please ask this question!"),
            )
          : Container(),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hackthon/AnswerScreen.dart';
import 'package:hackthon/main.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

typedef void StringCallback(String s);

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State with TickerProviderStateMixin {
  final _messages = <ChatMessage>[];
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addMessage(false, "您好我是FDEV，請問您今天有什麼問題呢？");
  }

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
    var responses = [
      "你有寫過程式嗎",
      "你有學過Flutter嗎？",
      "你早餐有吃飽嗎？",
      "你的問題是\"Flutter怎麼做進度條？\"嗎？",
    ];
    String response = responses[Random().nextInt(4)];
    bool isEnd = response=="你的問題是\"Flutter怎麼做進度條？\"嗎？";
    List<String> options = isEnd?null:["有喔", "沒有ㄟ"];
    addMessage(false, response, options: options, isEnd: isEnd);
  }

  void addMessage(bool isUser, String text,
      {List<String> options, bool isEnd = false}) {
    var message = ChatMessage(
        isUser: isUser,
        text: text,
        options: options,
        isEnd: isEnd,
        onTapOption: (option)=>_handleSubmitted(option),
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
    print(response.getMessage());
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.isUser,
      this.text,
      this.options,
      this.isEnd,
        this.onTapOption,
      this.animationController});

  final bool isUser;
  final bool isEnd;
  final String text;
  final List<String> options;
  final StringCallback onTapOption;
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
    return GestureDetector(
      onTap: ()=>onTapOption(tag),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffd2eefe),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(tag),
      ),
    );
  }

  Widget _buildAskQuestion(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => AnswerScreen(
        question: Question(
          "How to build progress bar in Flutter????", "I am using a future builder and a list view builder and I keep getting the vertical overflow error. I surrounded the ListView.builder() with a Container and gave it a fixed height but it's still ... ", ["Flutter", "progress-bar"]
        ),
        answer: """
        void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Custom Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WidgetCustom _widgetCustom;
  String _sMessage = "Fab has not been pressed";
  int _value = 99;

  @override
  void initState() {
    super.initState();
    _widgetCustom = WidgetCustom(iCount: _value, function: _update);
  }

  void _update(int value) {
    setState(() {
      _value = value;
      _widgetCustom = WidgetCustom(iCount: _value, function: _update);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          _widgetCustom,
          SizedBox(height: 40),
          Text(_sMessage),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fabPressed,
        tooltip: 'Get Value',
        child: Icon(Icons.add),
      ),
    );
  }

  _fabPressed() {
    setState(() => _sMessage = "Value from last button click =");
  }
}

class WidgetCustom extends StatefulWidget {
  final int iCount;
  final Function function;

  WidgetCustom({@required this.iCount, this.function});

  @override
  State<StatefulWidget> createState() {
    return _WidgetCustomState();
  }
}

class _WidgetCustomState extends State<WidgetCustom> {
  int _iCount;

  @override
  void initState() {
    super.initState();
    _iCount = widget.iCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              RaisedButton(child: const Text("Please tap me"), onPressed: (){
                _iCount = _iCount + 1;
                widget.function(_iCount);
              }),
              SizedBox(height: 40),
              Text("Tapped _iCount Times")
            ],
          ),
        ],
      ),
    );
  }
}
        """,
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
              child: Text("沒錯！請幫我問這個問題！"),
            )
          : Container(),
    );
  }
}

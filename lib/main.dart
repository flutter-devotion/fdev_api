import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

import 'ChatbotScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionListScreen(),
    );
  }
}

class QuestionListScreen extends StatefulWidget {
  final List<Question> questions = [
    Question("Flutter Spacer vs Expanded", "What is the difference between Expanded and Spacer in Flutter? Why Flutter team added Spacer when we already have Expanded? ", ["flutter", "dart"]),
    Question("How to do a dart flutter firebase query join [duplicate]", "I have a firestore table of users, and another firestore table of blogs which has uid on each document. I would like to do join query in flutter by joining the two tables by their uid. I can't find a ... ", ["flutter", "flutter-layout"]),
    Question("Flutter: Expanded vs Flexible", "I've used both Expanded and Flexible widgets and they seem to work same. Is there any difference between the two that I missed? ", ["dart", "flutter"]),
    Question("Can't pass data from home to results_page by Navigator.push() method", "There is a problem with this flutter app, and I cant find the solution as there is no error. what happens is when it navigates from home to the result page, the calculations doesn't happen or the ... ", ["tag1", "tag2", "tag3"]),
    Question("Flutter Spacer vs Expanded", "What is the difference between Expanded and Spacer in Flutter? Why Flutter team added Spacer when we already have Expanded? ", ["flutter", "dart"]),
    Question("How to do a dart flutter firebase query join [duplicate]", "I have a firestore table of users, and another firestore table of blogs which has uid on each document. I would like to do join query in flutter by joining the two tables by their uid. I can't find a ... ", ["flutter", "flutter-layout"]),
    Question("Flutter: Expanded vs Flexible", "I've used both Expanded and Flexible widgets and they seem to work same. Is there any difference between the two that I missed? ", ["dart", "flutter"]),
    Question("Can't pass data from home to results_page by Navigator.push() method", "There is a problem with this flutter app, and I cant find the solution as there is no error. what happens is when it navigates from home to the result page, the calculations doesn't happen or the ... ", ["tag1", "tag2", "tag3"]),
  ];

  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  String _keyword = "";
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var list = widget.questions.where((q) =>
        q.title.contains(_keyword) ||
        q.content.contains(_keyword) ||
        q.tags.any((s) => s.contains(_keyword)));
    if (list.length != 0) {
      children = <Widget>[
        _buildInput(),
        ...list.map((q) => _buildQuestion(q)),
      ];
    } else {
      children = <Widget>[
        _buildInput(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatScreen())),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text(
                  "找不到相似的問題，\n可能是您的問題太爛了，\n讓FDEV來教你怎麼問問題吧！",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ];
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ListView.separated(
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => Divider(),
        itemCount: children.length,
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xff2ac9fd),
      child: Row(children: <Widget>[
        Image.asset(
          "assets/logo.png",
          width: 48,
          height: 48,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "What's your question?",
                border: InputBorder.none,
              ),
              onChanged: (s) => setState(() => _keyword = s),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildQuestion(Question q) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(q.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff015da1),
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(q.content,
                style: TextStyle(
                  fontSize: 14,
                )),
          ),
          Row(children: <Widget>[
            ...q.tags.map(_buildTag),
          ]),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffd2eefe),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: TextStyle(),
      ),
    );
  }
}

class Question {
  final String title;
  final String content;
  final List<String> tags;

  Question(this.title, this.content, this.tags);
}

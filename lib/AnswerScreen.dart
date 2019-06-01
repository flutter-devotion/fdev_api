import 'package:flutter/material.dart';
import 'package:hackthon/main.dart';

class AnswerScreen extends StatelessWidget {
  final Question question;
  final String answer;

  const AnswerScreen({Key key, this.question, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo.png"),
        ),
      ),
      body: ListView(children: <Widget>[
        _buildQuestion(question),
        _buildAnswer(answer),
        _buildInput(),
      ]),
    );
  }

  Widget _buildQuestion(Question q) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

  Widget _buildAnswer(String answer) {
    return Container(
      color: Color(0xffd2eefe),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Answers",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff015da1),
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(answer,
                style: TextStyle(
                  fontSize: 14,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your Answer",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff015da1),
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: "What's your question?",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


https://flatteredwithflutter.com/merge-your-bots-in-flutter/
https://github.com/VictorRancesCode/flutter_dialogflow



dependencies:
  flutter:
    sdk: flutter
  flutter_dialogflow: ^0.1.0
  cupertino_icons: ^0.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:


  uses-material-design: true
  assets:
    - assets/credentials.json


"""

  void Response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(
        authGoogle: authGoogle, language: Language.chineseTraditional);
    AIResponse response = await dialogflow.detectIntent("你的訊息");
    print(response.getListMessage());
    //print(response.getMessage());//單一
  }

"""



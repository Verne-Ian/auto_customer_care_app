import 'package:auto_customer_care/addons/buttons&fields.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:ionicons/ionicons.dart';

class BotChat extends StatefulWidget {
  const BotChat({Key? key}) : super(key: key);

  @override
  State<BotChat> createState() => _BotChatState();
}

class _BotChatState extends State<BotChat> {
  final messageInsert = TextEditingController();
  List<Map> messsages = [];
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/others/auto_cred.json").build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "en");
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()![0]["text"]["text"][0].toString()
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            toolbarHeight: 60,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(0)),
            ),
            elevation: 10,
            title: const Text("Quick Help"),
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                  child: messsages.isEmpty
                      ? Center(
                          child: Card(
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                w * 0.1, h * 0.1, w * 0.1, h * 0.1),
                            child: const Text(
                              'Ask Me something',
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                        ))
                      : ListView.builder(
                          reverse: true,
                          itemCount: messsages.length,
                          itemBuilder: (context, index) => chat(
                              messsages[index]["message"].toString(),
                              messsages[index]["data"]))),
              const Divider(
                height: 8.0,
                indent: 10.0,
                endIndent: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: h * 0.002, top: h * 0.005),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child:
                            normalField('Add Message', false, messageInsert)),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            size: 20.0,
                          ),
                          onPressed: () {
                            if (messageInsert.text.isEmpty) {
                              print("empty message");
                            } else {
                              setState(() {
                                messsages.insert(0,
                                    {"data": 1, "message": messageInsert.text});
                              });
                              response(messageInsert.text);
                              messageInsert.clear();
                            }
                          }),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
          radius: const Radius.circular(15.0),
          color: data == 0 ? Colors.black : Colors.black45,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(data == 0
                      ? "assets/images/bot.png"
                      : "assets/images/user.png"),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }
}

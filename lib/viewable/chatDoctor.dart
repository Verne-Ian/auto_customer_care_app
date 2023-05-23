import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_customer_care/addons/buttons&fields.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class DocChat extends StatefulWidget {
  const DocChat({Key? key}) : super(key: key);

  @override
  State<DocChat> createState() => _DocChatState();
}

class _DocChatState extends State<DocChat> {

  final User? currentUser = FirebaseAuth.instance.currentUser;
  late String patientId = currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  final messageInsert = TextEditingController();
  List<Map> messages = [];

  Future<void> response(query) async {
    if (query == null || query.isEmpty) {
      return;
    }else{

      messageInsert.clear();

      // Get the chosen doctor's ID (Replace with your own logic to retrieve the doctor's ID)
      String doctorId = 'Uksssgtnymyuujv';

      // Save the patient's message to the doctor's collection
      CollectionReference doctorMessagesCollection =
      FirebaseFirestore.instance.collection('doctor_messages');

      await doctorMessagesCollection.add({
        'data': 1,
        'senderId': patientId,
        'receiverId': doctorId,
        'message': query,
        'timestamp': DateTime.now(),
      });

      setState(() {
        messages.insert(0, {
          "data": 0,
          "message": query,
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w * 1.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            toolbarHeight: 60,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(0)),
            ),
            elevation: 10,
            title: const Text("Quick Help"),
          ),
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Chats',
                  ),
                  const Spacer(),
                  StreamBuilder(
                      stream: firestore.collection('Users').doc(currentUser!.uid).snapshots(),
                      builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                        return !snapshot.hasData?Container(): Text(
                          'Last seen : ${DateFormat('hh:mm a').format(snapshot.data!['date_time'].toDate())}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        );
                      }
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
              Flexible(
                child: messages.isEmpty
                    ? Center(
                  child: SizedBox(
                    width: w * 0.95,
                    height: h * 0.3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: Colors.white,
                      elevation: 10.0,
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(w * 0.1, h * 0.1, w * 0.1, h * 0.02),
                            child: const Text(
                              'Ask me something!',
                              style: TextStyle(fontSize: 25.0),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // handle the first button press
                                  Navigator.pushNamed(context, '/ambie');
                                },
                                icon: const Icon(Ionicons.alert),
                                label: const Text('Ambulance'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  // handle the second button press
                                  Navigator.pushNamed(context, '/appoint');
                                },
                                icon: const Icon(Icons.book),
                                label: const Text('Make Appointment'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ): StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('doctor_messages')
                      .where('senderId', isEqualTo: patientId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return chat(
                            message['message'].toString(),
                            message['data'],
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const Divider(
                height: 8.0,
                indent: 10.0,
                endIndent: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: h * 0.005),
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                        child:
                        normalField('Add Message', false, messageInsert)),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            size: 25.0,
                          ),
                          onPressed: () {
                            if (messageInsert.text.isEmpty) {
                              print("empty message");
                            } else {
                              setState(() {
                                messages.insert(0,
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
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ChatBubble(
          backGroundColor: data == 0 ? Colors.indigo : Colors.blueGrey,
          clipper: data == 0
              ? ChatBubbleClipper2(type: BubbleType.receiverBubble, radius: 10.0)
              : ChatBubbleClipper2(type: BubbleType.sendBubble, radius: 10.0),
          elevation: 3.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(data == 0
                    ? "assets/images/bot.png"
                    : "assets/images/user.png"),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white, fontWeight: FontWeight.normal),
                  )),
              Padding(
                padding: EdgeInsets.zero,
                child: IconButton(
                    onPressed: (){},
                    icon: data == 1 ? const Icon(null) : const Icon(Icons.thumb_up, color: Colors.white, size: 15.0,)),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: IconButton(
                    onPressed: (){},
                    icon: data == 1 ? const Icon(null) : const Icon(Icons.thumb_down, color: Colors.white, size: 15.0,)),
              )
            ],
          )),
    );
  }
}
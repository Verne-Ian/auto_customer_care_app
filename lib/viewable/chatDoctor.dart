import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';

class DocChat extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String proName;
  const DocChat({Key? key, required this.senderId, required this.receiverId, required this.proName}) : super(key: key);

  @override
  State<DocChat> createState() => _DocChatState();
}

class _DocChatState extends State<DocChat> {

  TextEditingController messageText = TextEditingController();
  CollectionReference patientMessage = FirebaseFirestore.instance.collection('Interaction_Messages');

  void sendMessage(){
    String message = messageText.text.trim();

    if (message.isNotEmpty) {
      patientMessage.add({
        'senderId': widget.senderId,
        'recipientId': widget.receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        messageText.clear();
      }).catchError((error) {
        print('Error sending message: $error');
      });
    }
  }

  @override
  void dispose() {
    messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //This will retrieve the screen size of the device.
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title:  Text(widget.proName),
    ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: patientMessage
                  .where('senderId', isEqualTo: widget.senderId)
                  .where('recipientId', isEqualTo: widget.receiverId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: SizedBox(
                      width: w * 0.95,
                      height: h * 0.3,
                      child: SingleChildScrollView(
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
                    ),
                  );
                }else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var messageData = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      var message = messageData['message'] ?? '';
                      var data = messageData['senderId'] == widget.senderId
                          ? 1
                          : 0;
                      return docChat(message, data, context);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 8.0, right: 8.0, top: h * 0.005, bottom: h*0.005),
            margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                    child: normalField('Add Message', false, messageText)),
                SizedBox(width: w * 0.02,),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.black54, shape: BoxShape.circle),
                  child: IconButton(
                      icon: const Icon(
                        color: Colors.white,
                        Icons.send,
                        size: 25.0,
                      ),
                      onPressed: () {
                        if (messageText.text.isEmpty) {
                          print("empty message");
                        } else {
                          sendMessage();
                          messageText.clear();
                        }
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}

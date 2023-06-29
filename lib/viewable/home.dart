import 'package:auto_customer_care/viewable/chatDoctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../addons/drawer.dart';

class MyHome extends StatefulWidget {
   const MyHome({Key? key}) : super(key: key);


  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final CollectionReference firestore = FirebaseFirestore.instance.collection('Staff_Users');
  final User? user = FirebaseAuth.instance.currentUser;
  late final String? senderName = user!.displayName;



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxWidth: w),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const MainSideBar(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'M & S General Clinic',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(w * 0.01, h * 0.03, w * 0.01, h * 0.1),
            child: Column(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                FutureBuilder<User>(
                  future: Future.value(currentUser), // Wrap the currentUser in a Future
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userName = snapshot.data!.displayName; // Access the name property
                      return Text('Hello there, $userName!');
                    } else {
                      return const SpinKitDualRing(
                        color: Colors.black54,
                        size: 15.0,
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      // This widget is the receptionist and chat-bot tile.
                      child: newChatButton(
                          context, MedicalIcons.health_services, true, () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context){
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0))
                                    ),
                                    height: h * 0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:5.0, left: 3.0, right: 3.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: const CircleAvatar(
                                              foregroundImage: AssetImage('assets/images/bot.png'),
                                              backgroundColor: Colors.white,
                                            ),
                                            title: const Text('Quick Help'),
                                            subtitle: const Text('Get fast and Quick help from our ChatBot'),
                                            onTap: ()=> Navigator.pushNamed(context, '/chat'),
                                          ),
                                          Flexible(
                                            // This will fetch the available receptionist from the cloud DB.
                                            child: StreamBuilder(
                                                stream: firestore.where('Role', isEqualTo: 'Receptionist').snapshots(),
                                                builder: (context, snapshot){
                                                  if(snapshot.hasError){
                                                    return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                                  }else if(snapshot.connectionState == ConnectionState.none){
                                                    return Center(
                                                      child: Column(
                                                        children: const [
                                                          SizedBox(height: 10.0,),
                                                          Icon(Icons.cloud_off),
                                                          SizedBox(height: 10.0,),
                                                          Text('No Internet'),
                                                        ],),);
                                                  }else if(snapshot.connectionState == ConnectionState.waiting){
                                                    return Center(
                                                      child: Column(
                                                        children: const [
                                                          SizedBox(height: 10.0,),
                                                          SpinKitDualRing(color: Colors.blue, size: 30.0,),
                                                          SizedBox(height: 10.0,),
                                                          Text('Connecting'),
                                                        ],),);
                                                  }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                                    return Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [
                                                          SizedBox(height: 10.0,),
                                                          Icon(Icons.lock_person_outlined, color: Colors.blue, size: 30.0,),
                                                          SizedBox(height: 10.0,),
                                                          Text('Coming Soon'),
                                                        ],),);
                                                  }else if(snapshot.hasData){
                                                    final List<DocumentSnapshot> users = snapshot.data!.docs;

                                                    return ListView.builder(
                                                      itemCount: users.length,
                                                      itemBuilder: (context, index) {
                                                        // Access the user data for each document
                                                        final userData = users[index].data() as Map<String, dynamic>;

                                                        // Extract the desired fields from userData
                                                        final String userId = userData['UserId'] ?? '';
                                                        final String receiverName = userData['Name'] ?? '';
                                                        final String email = userData['Email'] ?? '';
                                                        final String? userPic = userData['ProfilePic'];

                                                        ImageProvider profilePic;
                                                        if(userPic == null ){
                                                          profilePic =  const AssetImage('assets/images/health-clinic.png');
                                                        }else{
                                                          profilePic = NetworkImage(userPic);
                                                        }

                                                        return ListTile(
                                                          leading: CircleAvatar(
                                                            foregroundImage: profilePic,
                                                          ),
                                                          title: Text(receiverName),
                                                          subtitle: Text(email),
                                                          onTap: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => DocChat(senderId: user!.uid, receiverId: userId, receiverName: receiverName, senderName: senderName,)));
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                  return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                      }, 'Quick Help / Receptionist'),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.black54,
                        height: 5.0,
                        thickness: 2.0,
                        indent: 15.0,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    SizedBox(
                      width: 45.0,
                      child: Text(
                        "Quick Services",
                        style: TextStyle(
                            fontSize: w * 0.03,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.black54,
                        height: 5.0,
                        thickness: 2.0,
                        endIndent: 15.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newChatButton(
                        context, Ionicons.ticket, true, () {

                      Navigator.pushNamed(context, '/appoint');
                    }, 'Make Appointment'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    newChatButton(context, MedicalIcons.ambulance, false, () {
                      Navigator.pushNamed(context, '/ambie');
                    }, 'Request Ambulance'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.black54,
                        height: 5.0,
                        thickness: 2.0,
                        indent: 15.0,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 45.0,
                      child: Text(
                        "Talk to our experts",
                        style: TextStyle(
                          fontSize: w * 0.03,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.black54,
                        height: 5.0,
                        thickness: 2.0,
                        endIndent: 15.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  // This row will handle the doctors available.
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newChatButton(context, Ionicons.medkit, false, () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0))
                              ),
                              height: h * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 3.0, right: 3.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: StreamBuilder(
                                          stream: firestore.where('Role', isEqualTo: 'Doctor').snapshots(),
                                          builder: (context, snapshot){
                                            if(snapshot.hasError){
                                              return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                            }else if(snapshot.connectionState == ConnectionState.none){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.cloud_off),
                                                    SizedBox(height: 10.0,),
                                                    Text('No Internet'),
                                                  ],),);
                                            }else if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    SpinKitDualRing(color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Connecting'),
                                                  ],),);
                                            }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.lock_person_outlined, color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Coming Soon'),
                                                  ],),);
                                            }else if(snapshot.hasData){
                                              final List<DocumentSnapshot> users = snapshot.data!.docs;

                                              return ListView.builder(
                                                itemCount: users.length,
                                                itemBuilder: (context, index) {
                                                  // Access the user data for each document
                                                  final userData = users[index].data() as Map<String, dynamic>;

                                                  // Extract the desired fields from userData
                                                  final String userId = userData['UserId'] ?? '';
                                                  final String receiverName = userData['Name'] ?? '';
                                                  final String email = userData['Email'] ?? '';
                                                  final String? userPic = userData['ProfilePic'];

                                                  ImageProvider profilePic;
                                                  if(userPic == null ){
                                                    profilePic =  const AssetImage('assets/images/surgeon.png');
                                                  }else{
                                                    profilePic = NetworkImage(userPic);
                                                  }

                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      foregroundImage: profilePic,
                                                    ),
                                                    title: Text('Dr.$receiverName'),
                                                    subtitle: Text(email),
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DocChat(senderId: user!.uid, receiverId: userId, receiverName: receiverName, senderName: senderName,)));
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                            return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          });
                    }, 'Doctors'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    newChatButton(context, MedicalIcons.dental, false, () {
                      // This widget will show the dentists available
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0))
                              ),
                              height: h * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 3.0, right: 3.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: StreamBuilder(
                                          stream: firestore.where('Role', isEqualTo: 'Dentist').snapshots(),
                                          builder: (context, snapshot){
                                            if(snapshot.hasError){
                                              return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                            }else if(snapshot.connectionState == ConnectionState.none){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.cloud_off),
                                                    SizedBox(height: 10.0,),
                                                    Text('No Internet'),
                                                  ],),);
                                            }else if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    SpinKitDualRing(color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Connecting'),
                                                  ],),);
                                            }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.lock_person_outlined, color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Coming Soon'),
                                                  ],),);
                                            }else if(snapshot.hasData){
                                              final List<DocumentSnapshot> users = snapshot.data!.docs;

                                              return ListView.builder(
                                                itemCount: users.length,
                                                itemBuilder: (context, index) {
                                                  // Access the user data for each document
                                                  final userData = users[index].data() as Map<String, dynamic>;

                                                  // Extract the desired fields from userData
                                                  final String userId = userData['UserId'] ?? '';
                                                  final String receiverName = userData['Name'] ?? '';
                                                  final String email = userData['Email'] ?? '';
                                                  final String? userPic = userData['ProfilePic'];

                                                  ImageProvider profilePic;
                                                  if(userPic == null ){
                                                    profilePic =  const AssetImage('assets/images/dentist.png');
                                                  }else{
                                                    profilePic = NetworkImage(userPic);
                                                  }

                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      foregroundImage: profilePic,
                                                    ),
                                                    title: Text('Dr.$receiverName'),
                                                    subtitle: Text(email),
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DocChat(senderId: user!.uid, receiverId: userId, receiverName: receiverName, senderName: senderName,)));
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                            return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          });
                    }, 'Dentist')
                  ],
                ),
                Row(
                  // This widget will work on the Pediatricians
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newChatButton(context, MedicalIcons.pediatrics, false, () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0))
                              ),
                              height: h * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 3.0, right: 3.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: StreamBuilder(
                                          stream: firestore.where('Role', isEqualTo: 'Pediatrician').snapshots(),
                                          builder: (context, snapshot){
                                            if(snapshot.hasError){
                                              return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                            }else if(snapshot.connectionState == ConnectionState.none){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.cloud_off),
                                                    SizedBox(height: 10.0,),
                                                    Text('No Internet'),
                                                  ],),);
                                            }else if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    SpinKitDualRing(color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Connecting'),
                                                  ],),);
                                            }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.lock_person_outlined, color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Coming Soon'),
                                                  ],),);
                                            }else if(snapshot.hasData){
                                              final List<DocumentSnapshot> users = snapshot.data!.docs;

                                              return ListView.builder(
                                                itemCount: users.length,
                                                itemBuilder: (context, index) {
                                                  // Access the user data for each document
                                                  final userData = users[index].data() as Map<String, dynamic>;

                                                  // Extract the desired fields from userData
                                                  final String userId = userData['UserId'] ?? '';
                                                  final String receiverName = userData['Name'] ?? '';
                                                  final String email = userData['Email'] ?? '';
                                                  final String? userPic = userData['ProfilePic'];

                                                  ImageProvider profilePic;
                                                  if(userPic == null ){
                                                    profilePic =  const AssetImage('assets/images/pediatrics.png');
                                                  }else{
                                                    profilePic = NetworkImage(userPic);
                                                  }

                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      foregroundImage: profilePic,
                                                    ),
                                                    title: Text('Dr.$receiverName'),
                                                    subtitle: Text(email),
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DocChat(senderId: user!.uid, receiverId: userId, receiverName: receiverName, senderName: senderName,)));
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                            return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          });
                    }, 'Pediatrician'),
                    const SizedBox(
                      width: 10.0,
                    ),
                    newChatButton(
                      // This will show the available physicians
                        context, Ionicons.disc, true, () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0))
                              ),
                              height: h * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 3.0, right: 3.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: StreamBuilder(
                                          stream: firestore.where('Role', isEqualTo: 'Physician').snapshots(),
                                          builder: (context, snapshot){
                                            if(snapshot.hasError){
                                              return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                            }else if(snapshot.connectionState == ConnectionState.none){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.cloud_off),
                                                    SizedBox(height: 10.0,),
                                                    Text('No Internet'),
                                                  ],),);
                                            }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    Icon(Icons.lock_person_outlined, color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Coming Soon'),
                                                  ],),);
                                            }else if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(
                                                child: Column(
                                                  children: const [
                                                    SizedBox(height: 10.0,),
                                                    SpinKitDualRing(color: Colors.blue, size: 30.0,),
                                                    SizedBox(height: 10.0,),
                                                    Text('Connecting'),
                                                  ],),);
                                            }else if(snapshot.hasData){
                                              final List<DocumentSnapshot> users = snapshot.data!.docs;

                                              return ListView.builder(
                                                itemCount: users.length,
                                                itemBuilder: (context, index) {
                                                  // Access the user data for each document
                                                  final userData = users[index].data() as Map<String, dynamic>;

                                                  // Extract the desired fields from userData
                                                  final String userId = userData['UserId'] ?? '';
                                                  final String receiverName = userData['Name'] ?? '';
                                                  final String email = userData['Email'] ?? '';
                                                  final String? userPic = userData['ProfilePic'];

                                                  ImageProvider profilePic;
                                                  if(userPic == null ){
                                                    profilePic =  const AssetImage('assets/images/surgeon.png');
                                                  }else{
                                                    profilePic = NetworkImage(userPic);
                                                  }

                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      foregroundImage: profilePic,
                                                    ),
                                                    title: Text('Dr.$receiverName'),
                                                    subtitle: Text(email),
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DocChat(senderId: user!.uid, receiverId: userId, receiverName: receiverName, senderName: senderName,)));
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                            return const Center(child: SpinKitDualRing(color: Colors.blue, size: 30.0,));
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          });
                    }, 'Physician')
                  ],
                ),
                /*TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Log-Out'))

                 */
              ],
            ),
          ),
        ),

      ),
    );
  }
}

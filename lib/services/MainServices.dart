import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:intl/intl.dart';

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static phoneLogin(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static Future<void> emailLogin(TextEditingController emailControl, TextEditingController passControl, String email, String password, BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: SpinKitDualRing(
                color: Colors.white70,
                size: 30.0,
              ),
            );
          });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password)
          .then((value){
        if(FirebaseAuth.instance.currentUser!.photoURL != null || FirebaseAuth.instance.currentUser!.displayName != null){
          Navigator.pushReplacementNamed(context, '/home');
          return Navigator.pop(context);
        }else{
          Navigator.pushReplacementNamed(context, '/addProfilePic');
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('User Not Found'),
              );
            });
        emailControl.text = '';
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
        passControl.text = '';
      }
    }

  }

  static Future<void> createWithEmail(
      TextEditingController nameControl,
      TextEditingController emailControl,
      TextEditingController passControl,
      TextEditingController genderControl,
      TextEditingController contactControl,
      String name,
      String gender,
      String contact,
      String email,
      String password,
      BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: SpinKitDualRing(
                color: Colors.white70,
                size: 30.0,
              ),
            );
          });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateDisplayName(name).then((value) async {
            // Save additional user data to Firestore
            await FirebaseFirestore.instance
                .collection('Patients')
                .doc(user.uid)
                .set({
              'UserId': user.uid,
              'Name': user.displayName,
              'Email': user.email,
              'ProfilePic': user.photoURL,
              'Contact': contact,
              'Gender': gender,
              'Date Of Birth': 'Add Date',
              'Residence': 'Where do you Stay?',
              'Keen': 'Next Of Keen',
              'Keen Contact': "Next Of Keen's contact",
              'Weight': '10',
              'Temp': '0',
              'Blood Pressure': '0'
            });
          });
        }
        if (FirebaseAuth.instance.currentUser!.photoURL != null &&
            FirebaseAuth.instance.currentUser!.displayName != null) {
          // ignore: use_build_context_synchronously
          return Navigator.pop(context);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/addProfilePic');
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('User Not Found'),
              );
            });
        emailControl.text = '';
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
        passControl.text = '';
      }
    }
  }

  static Future<User?> googleLogin() async {
      //beginning the sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //Obtaining the Authentication details from the Google sign in Request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //Creates a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      //This will sign in the user
      final appUser = await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = appUser.user;

      if (user != null) {
        // Save additional user data to Firestore
        await FirebaseFirestore.instance.collection('Patients').doc(user.uid).set({
          'UserId': user.uid,
          'Name': user.displayName,
          'Email': user.email,
          'ProfilePic': user.photoURL,
          'Contact': user.phoneNumber,
          'Gender': 'Select',
          'Date Of Birth': 'Add Date',
          'Residence': 'Where do you Stay?',
          'Keen': 'Next Of Keen',
          'Keen Contact': "Next Of Keen's contact",
          'Weight': '10',
          'Temp': '0',
          'Blood Pressure': '0'
          // Add more fields as needed
        });
      }

      return appUser.user;
  }
}

class AllServices{
  static Future<void> selectDate(Function setState,BuildContext context, TextEditingController dateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
        final DateFormat formatter = DateFormat('EEEE, MMMM d, yyyy');
        setState((){
          final String formattedDate = formatter.format(picked);
          dateController.text = formattedDate;
        });
      }
    }

  // Function for selecting or taking a profile picture
  static Future<String?> selectProfilePicture(BuildContext context, File pickedFile, String name) async {
    File imageFile = File(pickedFile.path);

    // Upload image to Firebase Storage
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Profile_Pics')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await ref.putFile(imageFile);

      // Get image URL from Firebase Storage
      final url = await ref.getDownloadURL();

      // Update user profile picture in Firebase Auth
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

      // Update user profile picture in Firestore
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'ProfilePic': url, 'Name': name}).then((value) => Navigator.pushReplacementNamed(context, '/home'));

      return url;
    } catch (error) {
      print(error);
    }
    return null;
  }

  static late String? chatRoomId;

  static Future<void> createChatRoom(List<Map<String, String?>> participants) async {
    CollectionReference chatRooms =
    FirebaseFirestore.instance.collection('ChatRooms');

    try {
      // Sort participant IDs to ensure consistent document ID generation
      List<String?> participantIds = participants.map((participant) => participant['id']).toList()..sort();

      // Generate a unique chat room ID based on sorted participant IDs
      chatRoomId = participantIds.join('_');

      final chatRoomRef = chatRooms.doc(chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();

      if (!chatRoomSnapshot.exists) {
        await chatRoomRef.set(
          {
            'participants': participants,
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    } catch (error) {
      print('Error creating chat room: $error');
      rethrow;
    }
  }

  static Future<void> sendMessageToChatRoom(
      String chatRoomId,
      String senderId,
      String? senderName,
      String receiverId,
      String receiverName,
      String message,
      String? audioFilePath,
      String? imageFilePath,
      String? videoFilePath,
      String? documentFilePath,
      ) async {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    try {
      if (audioFilePath != '') {
        // Handle audio message
        String audioUrl = await uploadAudioMessage(audioFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'audio', // Indicate it's an audio message
          'message': audioUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set(
          {
            'lastMessage': {
              'message': audioUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      }else if(imageFilePath != ''){
        String imageUrl = await uploadImageMessage(imageFilePath!); // Upload image file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'image', // Indicate it's an image message
          'message': imageUrl, // Store the URL of the image file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set(
          {
            'lastMessage': {
              'message': imageUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      } else if(videoFilePath != ''){
        // Handle sending video message

        String videoUrl = await uploadVideoMessage(videoFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'video', // Indicate it's an audio message
          'message': videoUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set(
          {
            'lastMessage': {
              'message': videoUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      }else if(documentFilePath != ''){
        // Handle sending document message
        String documentUrl = await uploadDocumentMessage(documentFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'document', // Indicate it's an audio message
          'message': documentUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set(
          {
            'lastMessage': {
              'message': documentUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      }
      else {
        // Handle text message
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'text', // Indicate it's a text message
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update the last message in the chat room
        await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set(
          {
            'lastMessage': {
              'message': message,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );

      }
    } catch (error) {
      print('Error sending message: $error');
      rethrow;
    }
  }

  // Function for saving a video message to Firebase Storage
  static Future<String> uploadVideoMessage(String videoFilePath) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('chat_videos').child('${DateTime.now().millisecondsSinceEpoch}.mp4');
    UploadTask uploadTask = storageReference.putFile(File(videoFilePath));
    await uploadTask.whenComplete(() {});
    String videoUrl = await storageReference.getDownloadURL();
    return videoUrl;
  }

  // Function for saving a document message to Firebase Storage
  static Future<String> uploadDocumentMessage(String documentFilePath) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('document_messages').child('${DateTime.now().millisecondsSinceEpoch}.pdf');
    UploadTask uploadTask = storageReference.putFile(File(documentFilePath));
    await uploadTask.whenComplete(() {});
    String documentUrl = await storageReference.getDownloadURL();
    return documentUrl;
  }

  static Future<String> uploadAudioMessage(String audioFilePath) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('audio_messages').child('${DateTime.now().millisecondsSinceEpoch}.m4a');
    UploadTask uploadTask = storageReference.putFile(File(audioFilePath));
    await uploadTask.whenComplete(() {});
    String audioUrl = await storageReference.getDownloadURL();
    return audioUrl;
  }

  // Function for saving an image message to Firebase Storage
  static Future<String> uploadImageMessage(String imageFilePath) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('image_messages').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageReference.putFile(File(imageFilePath));
    await uploadTask.whenComplete(() {});
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }


  static Stream<QuerySnapshot> streamUserChatRoom(String? userId, String? userName) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('participants', arrayContains: {'id': userId, 'name': userName})
        .snapshots();
  }

  static Stream<QuerySnapshot> lastChatRoom(String? userId, String? userName) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('participants', arrayContains: {'id': userId, 'name': userName})
        .orderBy('lastMessage.timestamp', descending: false)
        .snapshots();
  }

  // Function to stream query snapshot of user data from Firestore

  static Stream<QuerySnapshot> streamUsers(String? userId) {
    return FirebaseFirestore.instance.collection('users').where('userId', isEqualTo: userId).snapshots();
  }

  static Stream<QuerySnapshot> streamLastMessages(String? chatRoomId) {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    return chatRoomCollection
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamMessages(String? chatRoomId) {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    return chatRoomCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

}
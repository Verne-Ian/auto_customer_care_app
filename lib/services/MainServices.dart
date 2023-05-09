import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static phoneLogin(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static Future<User?> googleLogin() async {
    if (kIsWeb) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Trigger the authentication flow
      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        // Return the user object
        return userCredential.user;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      //beginning the sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //Obataining the Authentication details from the Google sign in Request
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      //Creates a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

      //This will sign in the user
      final appUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return appUser.user;
    }
  }
}

class MyUser {
  final String id;
  final String name;
  final String imageUrl;

  MyUser({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory MyUser.fromFirebaseUser(User firebaseUser) {
    return MyUser(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      imageUrl: firebaseUser.photoURL ?? '',
    );
  }
}

class Message {
  late String id;
  late String text;
  late String imageUrl;
  final MyUser sender;
  final Timestamp time;

  Message({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'sender': {
        'id': sender.id,
        'name': sender.name,
        'imageUrl': sender.imageUrl,
      },
      'time': time,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    final senderMap = map['sender'] as Map<String, dynamic>;
    final sender = MyUser(
      id: senderMap['id'],
      name: senderMap['name'],
      imageUrl: senderMap['imageUrl'],
    );

    return Message(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      sender: sender,
      time: map['time'],
    );
  }
}

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late MyUser _currentUser;
  List<Message> _messages = [];

  ChatProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _currentUser = MyUser.fromFirebaseUser(user);
      }
    });
  }

  MyUser get currentUser => _currentUser;
  List<Message> get messages => _messages;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  Future<void> sendMessage(String text, XFile? image) async {
    try {
      final ref = _storage.ref().child('ChatImages/${DateTime.now().toString()}');

      late String? imageUrl;
      if (image != null) {
        if (kIsWeb) {
          imageUrl = await ref.putData(await image.readAsBytes()).then((task) => task.ref.getDownloadURL());
        } else {
          imageUrl = await ref.putFile(image as File).then((task) => task.ref.getDownloadURL());
        }
      } else {
        imageUrl = null;
      }

      final message = Message(
          id: '',
          text: text,
          imageUrl: imageUrl ?? '',
          sender: _currentUser,
          time: Timestamp.now());

      await FirebaseFirestore.instance.collection('messages').add(message.toMap());
    } catch (error) {
      print(error);
    }
  }


  void loadMessages() {
    _db.collection('messages').orderBy('time').snapshots().listen((snapshot) {
      _messages =
          snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
      notifyListeners();
    });
  }
}

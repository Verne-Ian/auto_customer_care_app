import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

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
  final String id;
  final String text;
  final String imageUrl;
  final MyUser sender;
  var time;

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
      id: senderMap['id'] as String,
      name: senderMap['name'] as String,
      imageUrl: senderMap['imageUrl'] as String,
    );

    return Message(
      id: map['id'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String,
      sender: sender,
      time: map['time'] as Timestamp,
    );
  }
}

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<void> sendMessage(String text, File? image) async {
    try {
      final ref =
          _storage.ref().child('ChatImages/${DateTime.now().toString()}');

      final String? imageUrl;
      if (image != null) {
        if (kIsWeb) {
          imageUrl = await ref
              .putData(await image.readAsBytes())
              .then((task) => task.ref.getDownloadURL());
        } else {
          imageUrl = await ref
              .putFile(image)
              .then((task) => task.ref.getDownloadURL());
        }
      } else {
        imageUrl = null;
      }

      final message = Message(
          id: '',
          text: text,
          imageUrl: imageUrl ?? '',
          sender: _currentUser,
          time: FieldValue.serverTimestamp());

      await _db.collection('messages').add(message.toMap());
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

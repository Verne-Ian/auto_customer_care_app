import 'package:firebase_auth/firebase_auth.dart';

class Login{
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static Future<UserCredential> emailLogin(String email, String password){
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static phoneLogin(String phone){
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static googleLogin(){
    return FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }

}

class newUser{
  String userID;
  String password;
  String phone;

  newUser({required this.userID, required this.password, required this.phone});

  static emailSignUp(String email, String password){
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

}
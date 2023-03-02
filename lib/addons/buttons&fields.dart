

import 'package:flutter/material.dart';

///This can be used if you want custom but similar text fields throughout the app
///for number or text fields.
///You can edit it's appearance as desired.
TextField defaultField(String text, IconData icon, bool isDigit,
    TextEditingController controller, String unit){
  return TextField(
    controller: controller,
    obscureText: isDigit,
    enableSuggestions: isDigit,
    autocorrect: isDigit,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      suffixText: unit,
      suffixStyle: const TextStyle(
        color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 20.0),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 2)
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      fillColor: Colors.black.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: 0, style: BorderStyle.solid, color: Colors.black.withOpacity(0.3))
      ),
    ),
    keyboardType: isDigit ? TextInputType.number : TextInputType.text,
  );

}

///This can be used if you want custom but similar text fields throughout the app
///for password or email fields.
///You can edit it's appearance as desired.
TextField otherField(String text, IconData icon, bool isPassword,
    TextEditingController controller){
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: isPassword,
    autocorrect: isPassword,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 2)
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.black.withOpacity(0.4),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.solid, color: Colors.black.withOpacity(0.3))
      ),
    ),
    keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );

}


///This can be used if you want custom but similar login or signup buttons throughout the app.
///You can edit it as desired.
Container loginSignUpButton(BuildContext context, bool isLogin, Function onTap){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(onPressed: () {onTap();},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states){
          if(states.contains(MaterialState.pressed)){
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ))),
    child: Text(
      isLogin ? 'Log In' : 'Sign Up',
      style: const TextStyle(
        color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
      ),
    ),
    ),
  );

}

///This can be used if you want custom but similar buttons throughout the app.
///You can edit it as desired.
Container normalButton(BuildContext context, String text, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(onPressed: () {
      onTap();
    },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
        ),
      ),
    ),
  );
}
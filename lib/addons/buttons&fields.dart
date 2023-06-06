import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

///This can be used if you want custom but similar text fields throughout the app
///for number or text fields.
///You can edit it's appearance as desired.
TextFormField defaultField(String text, IconData icon, bool isDigit,
    TextEditingController controller, String unit) {
  return TextFormField(
    controller: controller,
    obscureText: isDigit,
    enableSuggestions: isDigit,
    autocorrect: isDigit,
    cursorHeight: 20.0,
    cursorColor: Colors.white,
    validator: (value){
      if (value == null || value.isEmpty) {
        return 'Please enter your $text';
      }
      return null;
    },
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      suffixText: unit,
      suffixStyle: const TextStyle(
          color: Colors.white70, fontWeight: FontWeight.bold),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 1)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              width: 0,
              style: BorderStyle.solid,
              color: Colors.black.withOpacity(0.3))),
    ),
    keyboardType: isDigit ? TextInputType.number : TextInputType.text,
  );
}

///This can be used if you want custom but similar text fields throughout the app
///for password or email fields.
///You can edit it's appearance as desired.
TextFormField otherField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: isPassword,
    autocorrect: isPassword,
    cursorHeight: 20.0,
    cursorColor: Colors.white,
    validator: (value){
      if (value == null || value.isEmpty) {
        return 'Please enter your $text';
      }
      return null;
    },
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
          borderSide: const BorderSide(color: Colors.white, width: 1)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(color: Colors.white),
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              width: 0,
              style: BorderStyle.solid,
              color: Colors.black.withOpacity(0.1))),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

LayoutBuilder normalField(
    String hint, bool isDigit, TextEditingController controller) {
  return LayoutBuilder(
    builder: (context , constraints ) {
      return TextField(
      controller: controller,
      obscureText: isDigit,
      enableSuggestions: isDigit,
      autocorrect: isDigit,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: getFontSize(constraints.maxHeight)),
      maxLines: null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 16.0),
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.white, width: 0)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        fillColor: Colors.black.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                width: 0,
                style: BorderStyle.solid,
                color: Colors.blueGrey.withOpacity(0.1))),
      ),
      keyboardType: isDigit ? TextInputType.number : TextInputType.text,
    );
    }
  );
}
double getFontSize(double height) {
  if (height < 60) {
    return 25.0;
  } else if (height < 90) {
    return 20.0;
  } else {
    return 16.0;
  }
}


///This can be used if you want custom but similar login or signup buttons throughout the app.
///You can edit it as desired.
Container loginSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'Log In' : 'Sign Up',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
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
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names, non_constant_identifier_names
///This can be used if you want custom but similar login or signup buttons throughout the app.
///You can edit it as desired.
Container GoogleSignUpButton(
    BuildContext context, IconData icons, bool isGoogle, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      icon: Icon(
        icons,
        color: Colors.green,
        size: 30.0,
      ),
      label: Text(
        isGoogle ? 'Sign In With Google' : 'Sign In With Microsoft',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Container newChatButton(
    BuildContext context, IconData icons, bool isBot, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.45,
    height: MediaQuery.of(context).size.height * 0.15,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white70;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      icon: Icon(
        icons,
        color: Colors.black54,
        size: 30.0,
      ),
      label: Text(
        text,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04),
      ),
    ),
  );
}

Widget botChat(String message, int data, context) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  return Padding(
    padding: data == 0 ? const EdgeInsets.only(bottom: 5.0, right: 15.0) : const EdgeInsets.only(bottom: 5.0, left: 15.0),
    child: ChatBubble(
        backGroundColor: data == 0 ? Colors.indigo : Colors.blueGrey,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 5.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 5.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.zero,
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
                    style: TextStyle(
                        fontSize: h * 0.02,
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
              ),
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
          ),
        )),
  );
}

Widget docChat(String message, int data, context) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  return Padding(
    padding: data == 0 ? const EdgeInsets.only(bottom: 5.0, right: 15.0) : const EdgeInsets.only(bottom: 5.0, left: 15.0),
    child: ChatBubble(
        backGroundColor: data == 0 ? Colors.indigo : Colors.blueGrey,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 5.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 5.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.zero,
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
                  style: TextStyle(
                      fontSize: h * 0.02,
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
        )),
  );
}

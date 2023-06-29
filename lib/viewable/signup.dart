import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController genderControl = TextEditingController();
  TextEditingController contactControl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: w),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.0, h * 0.1, w * 0.0, h * 0.01),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: w * 0.3,
                        height: w * 0.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              opacity: 0.9,
                              image: AssetImage("assets/images/hospital.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      SizedBox(
                        width: w*0.3,
                        child: Text(
                          "M & S General Clinic",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 0.8,
                              color: Colors.black54, fontSize: w * 0.065, fontFamily: 'DancingScript'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Register Now",
                            style: TextStyle(
                                color: Colors.black54, fontSize: w * 0.09, fontFamily: 'DancingScript'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultField('Preferred Name', Ionicons.person, false,
                              nameControl, ''),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultField('Gender', Ionicons.male_female_outline, false,
                              genderControl, ''),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultField('Phone Number', Icons.phone, true,
                              contactControl, ''),
                          const SizedBox(
                            height: 10.0,
                          ),
                          otherField(
                              'Email', Icons.email, false, emailControl),
                          const SizedBox(
                            height: 10.0,
                          ),
                          otherField('Password', Icons.lock, true,
                              passControl),
                          const SizedBox(
                            height: 10.0,
                          ),
                          loginSignUpButton(context, false, () async {
                            if(_formKey.currentState!.validate()){
                              Login.createWithEmail(
                                  nameControl,
                                  emailControl,
                                  passControl,
                                  genderControl,
                                  contactControl,
                                  nameControl.text,
                                  genderControl.text,
                                  contactControl.text,
                                  emailControl.text, passControl.text, context);
                            }
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.black54,
                                  height: 5.0,
                                  thickness: 2.0,
                                  indent: 15.0,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: 30.0,
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black54,
                                  height: 5.0,
                                  thickness: 2.0,
                                  endIndent: 15.0,
                                ),
                              ),
                            ],
                          ),
                          GoogleSignUpButton(context, Ionicons.logo_google, true,
                              () {
                            Login.googleLogin();
                          }),
                          haveAccountOption(),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row haveAccountOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an Account?',
            style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text(
            'Login Instead',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

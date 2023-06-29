import 'package:auto_customer_care/addons/buttons&fields.dart';
import 'package:auto_customer_care/services/MainServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

class UserProfile extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? profilePic;
  const UserProfile({Key? key, required this.userName, required this.email, required this.profilePic}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _keenController = TextEditingController();
  final TextEditingController _keenContactController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance.collection('Patients');
  CollectionReference appointment = FirebaseFirestore.instance.collection('appointments');
  bool edit = true;

  saveButton(){
    if(edit == false){
      return ElevatedButton(
        onPressed: () async {
          await user!.updateDisplayName(_nameController.text);
          await firestore.doc(user!.uid).update({
            'Name': _nameController.text,
            'Date Of Birth': _dateController.text,
            'Gender': _genderController.text,
            'Keen': _keenController.text,
            'Keen Contact': _keenContactController.text,
            'Residence': _residenceController.text
          });
          setState(() {
            edit = true;
          });


        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.black54;
            }),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
        child: const Text('Done'),
      );
    }
    return const SizedBox();
  }

  @override
  void initState() {
    saveButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String topText = edit == true ? "My Profile" : "Editing profile";
    ImageProvider userPic;
    if(widget.profilePic == null ){
      userPic =  const AssetImage('assets/images/bot.png');
    }else{
      userPic = NetworkImage("${widget.profilePic}");
    }
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: edit == true ? Colors.green : Colors.black54,
        title: Text(topText),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: w * 0.03, bottom: 8.0, right: w * 0.03, top: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.where('UserId', isEqualTo: user!.uid).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final profile = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: profile.length,
                        itemBuilder: (context, index){
                        final userData = profile[index].data() as Map<String, dynamic>;

                        edit == true ? _nameController.text = userData['Name'] : null;
                        edit == true ? _dateController.text = userData['Date Of Birth'] : null;
                        edit == true ? _genderController.text = userData['Gender'] : null;
                        edit == true ? _keenController.text = userData['Keen'] : null;
                        edit == true ? _keenContactController.text = userData['Keen Contact'] : null;
                        edit == true ? _residenceController.text = userData['Residence'] : null;

                        String weight = userData['Weight'];
                        String temp = userData['Temp'];
                        String bP = userData['BloodPressure'];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: w * 0.5,
                              height: w * 0.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    opacity: 0.3,
                                    image: userPic,
                                    fit: BoxFit.contain),
                              ),
                              child: IconButton(onPressed: (){
                                setState(() {
                                  edit = false;
                                });
                                saveButton();
                              }, icon: Icon(Icons.edit_note, size: w*0.15,)),
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text('Name')),
                                const SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 3,
                                  child: profileField('', Icons.person, false, _nameController, edit)
                                ),
                              ],
                            ),
                            const SizedBox(height: 25.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.black54,
                                    height: 5.0,
                                    thickness: 2.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: 45.0,
                                  child: Text(
                                    "Bio Data",
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text('Gender',  textAlign: TextAlign.left)),
                                const SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 3,
                                  child: profileField('', Ionicons.male_female_outline, false, _genderController, edit),
                                ),
                                edit == false ? IconButton(
                                    onPressed: (){
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context){
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                  borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(30.0),
                                                      topLeft: Radius.circular(30.0))
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(Ionicons.male),
                                                    title: const Text('Male'),
                                                    onTap: (){
                                                      _genderController.text = 'Male';
                                                      Navigator.pop(context);},
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(Ionicons.female_outline),
                                                    title: const Text('Female'),
                                                    onTap: (){
                                                      _genderController.text = 'Female';
                                                      Navigator.pop(context);},
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.change_circle)) : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text('Date Of Birth', textAlign: TextAlign.left,)),
                                const SizedBox(width: 10.0,),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      if(edit == false){
                                        AllServices.selectDate(setState, context, _dateController);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7.0, horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _dateController.text.isNotEmpty ? _dateController.text : '',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.calendar_today),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text('Area of residence', textAlign: TextAlign.left,)),
                                const SizedBox(width: 10.0,),
                                Expanded(flex: 3, child: profileField('', Icons.location_on_outlined, false, _residenceController, edit)),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text('Next of keen', textAlign: TextAlign.left,)),
                                const SizedBox(width: 10.0,),
                                Expanded(flex: 3, child: profileField('', Icons.people, false, _keenController, edit)),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(flex: 1, child: Text("Next of keen's contact", textAlign: TextAlign.left,)),
                                const SizedBox(width: 10.0,),
                                Expanded(flex: 3, child: profileField('', Icons.phone, true, _keenContactController, edit)),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.black54,
                                    height: 5.0,
                                    thickness: 2.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: 45.0,
                                  child: Text(
                                    "Last visit Records",
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('Weight'),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(weight ?? '10'),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        const Text('Kg'),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('Temperature'),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(temp ?? '0'),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        const Text('⁰C'),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text('Blood Pressure'),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(bP ?? '0'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            saveButton()
                          ],
                        );
                        }),
                  ),
                ],
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Column(
                  children: const [
                    SizedBox(height: 10.0,),
                    SpinKitDualRing(color: Colors.blue, size: 30.0,),
                    SizedBox(height: 10.0,),
                    Text('Connecting'),
                  ],),);
            }else if(snapshot.connectionState == ConnectionState.none){
              Center(
                child: Column(
                  children: const [
                    SizedBox(height: 10.0,),
                    Icon(Icons.cloud_off),
                    SizedBox(height: 10.0,),
                    Text('No Internet'),
                  ],),);
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}

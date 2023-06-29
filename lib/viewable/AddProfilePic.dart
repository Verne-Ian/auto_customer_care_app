import 'dart:io';

import 'package:auto_customer_care/addons/buttons&fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/MainServices.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({Key? key}) : super(key: key);

  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {
  File? _imageFile;
  TextEditingController nameController = TextEditingController();

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ImageProvider userPic;
    if(_imageFile == null){
      userPic =  const AssetImage('assets/images/user.png');
    }else{
      userPic = FileImage(_imageFile!);
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile Picture'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: userPic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return Colors.green;
                          }),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        _selectImage(ImageSource.gallery);
                      },
                      child: const Text('Select from Gallery'),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return Colors.green;
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                        onPressed: () {
                          _selectImage(ImageSource.camera);
                        },
                        child: const Text('Take Picture'),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                defaultField('Enter your name', Icons.person, false, nameController, ''),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black26;
                        }
                        return Colors.green;
                      }),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    _imageFile == null
                        ? null
                        : AllServices.selectProfilePicture(
                        context, _imageFile!, nameController.text)
                        .then((value) => Navigator.pushReplacementNamed(context, '/home'));
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AmbulanceRequestPage extends StatefulWidget {
  const AmbulanceRequestPage({super.key});

  @override
  _AmbulanceRequestPageState createState() => _AmbulanceRequestPageState();
}

class _AmbulanceRequestPageState extends State<AmbulanceRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {

      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection('ambulance_requests').add({
          'name': currentUser?.displayName,
          'location': _locationController.text,
          'contact': _contactController.text,
          'status': 'Pending',
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ambulance request submitted!'),
              backgroundColor: Colors.green,
            ),
          );
        }).onError((error, stackTrace){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to submit ambulance request. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to submit ambulance request. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final appBar = AppBar(
      title: const Text('Ambulance Request from',
          style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.black54,
      centerTitle: true,
    );
    final formHeight = screenHeight -
        appBar.preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('${currentUser?.displayName}',
                      style: const TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the patient's location";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _contactController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter caretaker's contact";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        _submitRequest();
                        _locationController.clear();
                        _contactController.clear();

                        },
                      child: const Text('Request'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}